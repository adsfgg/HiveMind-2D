if not Server then return end

Script.Load("lua/Overview/Trackers/GeneralTracker.lua")
Script.Load("lua/Overview/Trackers/PlayerTracker.lua")
Script.Load("lua/Overview/Trackers/PlayerSpecificsTracker.lua")
Script.Load("lua/Overview/Trackers/TeamTracker.lua")
Script.Load("lua/Overview/GameStateMonitor.lua")
Script.Load("lua/Overview/SaveSend.lua")
Script.Load("lua/Overview/uuid.lua")

local updatesPerSecond = 10

local uuid = GetUUIDLibrary()

local gameStateMonitor
local lastTime = 0
local delay

local trackers = {}

local header = {}
local update_data = {}

local total_update_time = 0
local updates = 0

local keyframes = 0
local keyframe_interval = 2 -- seconds
local last_keyframe_time = 0

local function UpdateTrackers(keyFrame)
    local start_time = Shared.GetTime()
    local trackerData = {}

    for _,tracker in ipairs(trackers) do
        tracker:SetKeyframe(keyFrame)
        local data = tracker:OnUpdate()
        if data then
            trackerData[tracker:GetName()] = data
        end
    end

    -- we probably need a way to find keyframes easily.
    if keyFrame then
        trackerData["keyframe"] = keyframes
        keyframes = keyframes + 1
    end

    if next(trackerData) ~= nil then
        --update_data[tostring(updates)] = trackerData
        table.insert(update_data, trackerData)
    end

    local end_time = Shared.GetTime()
    local time_taken = end_time - start_time

    total_update_time = total_update_time + math.max(0, time_taken)

    updates = updates + 1
end

local function OnUpdateServer()
    local now = Shared.GetTime()
    local keyFrame = false

    if gameStateMonitor:CheckGameState() and lastTime + delay < now then
        lastTime = now
        if last_keyframe_time + keyframe_interval < now then
            last_keyframe_time = now
            keyFrame = true
        end

        UpdateTrackers(keyFrame)
    end
end

local function SendChatMessage(msg)
    Server.SendNetworkMessage("Chat", BuildChatMessage(false, "Overview", -1, kTeamReadyRoom, kNeutralTeamType, msg), true)
    Shared.Message("Chat All - " .. "Overview" .. ": " .. msg)
    Server.AddChatToHistory(msg, "Overview", 0, kTeamReadyRoom, false)
end

class 'Overview'

function Overview:InitTrackers()
    table.insert(trackers, GeneralTracker())
    table.insert(trackers, PlayerTracker())
    table.insert(trackers, PlayerSpecificsTracker())
    table.insert(trackers, TeamTracker())
end

function Overview:Initialize()
    uuid.seed()
    gameStateMonitor = GameStateMonitor()

    self:InitTrackers()

    delay = 1 / updatesPerSecond
    Event.Hook("UpdateServer", OnUpdateServer)
end

function Overview:GetGametime()
    return math.max( 0, math.floor(Shared.GetTime()) - GetGameInfoEntity():GetStartTime() )
end

function Overview:Reset()
    lastTime = 0
    header = {}
    update_data = {}
    total_update_time = 0
    updates = 0

    for _,tracker in ipairs(trackers) do
        tracker:OnReset()
    end

    self:InitHeader()
end

local function BuildModList()
    local modList = {}

    for i = 1, Server.GetNumMods() do
        local id   = Server.GetModId(i)
        local name = Server.GetModTitle(i)
        modList[i] = { id = id, name = name }
    end

    return modList
end

local function BuildServerInfo()
    local serverInfo = {}

    serverInfo['name'] = Server.GetName()
    serverInfo['is_dedicated'] = Server.IsDedicated()
    serverInfo['ip'] = Server.GetIpAddress()
    serverInfo['mods'] = BuildModList()

    return serverInfo
end

function Overview:InitHeader()
    header = {}
    header['ns2_build_number'] = Shared.GetBuildNumber()
    header['round_id'] = uuid.new()
    header['map'] = Shared.GetMapName()
    header['start_time'] = os.date("%X")
    header['start_date'] = os.date("%x")
    header['server_info'] = BuildServerInfo()

    -- init these but we need to set their values later in OnGameEnd. We can use these values to check if the data is complete.
    header['winning_team'] = -1
    header['round_length'] = -1
    header['end_time'] = -1
    header['end_date'] = -1
    header['average_update_time'] = -1
end

function Overview:FinalizeHeaders()

    local winning_team = -1
    local currentState = GetGamerules():GetGameState()

    if currentState == kGameState.Team1Won then
        winning_team = kTeam1Index
    elseif currentState == kGameState.Team2Won then
        winning_team = kTeam2Index
    elseif currentState == kGameState.Draw then
        winning_team = 0
    end

    header['winning_team'] = winning_team
    header['round_length'] = self:GetGametime()
    header['end_time'] = os.date("%X")
    header['end_date'] = os.date("%x")
    header['update_resolution'] = updatesPerSecond
    header['updates'] = updates
    header['total_update_time'] = total_update_time
    if updates > 0 then
        header['average_update_time'] = total_update_time / updates
    else
        header['average_update_time'] = 0
    end
end

function Overview:OnCountdownStart()
    self:Reset()
    SendChatMessage("Recording overview demo")
end

function Overview:OnGameStart()
    lastTime = 0 -- force an update.
end

function Overview:OnGameEnd()
    self:FinalizeHeaders()

    -- initialize the json structure
    jsonStructure = {}
    jsonStructure['header'] = header
    jsonStructure['update_data'] = update_data

    -- save the data locally then send it to the server.
    SaveAndSendRoundData(jsonStructure)

    -- notify the players that the demo was saved successfully.
    SendChatMessage("Demo recorded. Round Id: " .. jsonStructure['header']['round_id'])
end
