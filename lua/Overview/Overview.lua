if not Server then return end

Script.Load("lua/Overview/Trackers/GeneralTracker.lua")
Script.Load("lua/Overview/GameStateMonitor.lua")
Script.Load("lua/Overview/SaveSend.lua")
Script.Load("lua/Overview/uuid.lua")

local updatesPerSecond = 2 -- trackers update twice every second.

local uuid = GetUUIDLibrary()

local gameStateMonitor
local lastTime = 0
local delay

local trackers = {}

local header = {}
local update_data = {}

local function UpdateTrackers()
    print("Updating trackers...")
    local trackerData = {}

    for _,tracker in ipairs(trackers) do
        local data = tracker:OnUpdate()
        trackerData[tracker:GetName()] = data
    end

    table.insert(update_data, trackerData)
end

local function OnUpdateServer()
    if lastTime + delay < Shared.GetTime() then
        lastTime = Shared.GetTime()

        if gameStateMonitor:CheckGameState() then
            UpdateTrackers()
        end
    end
end

local function SendChatMessage(msg)
    Server.SendNetworkMessage("Chat", BuildChatMessage(false, "Overview", -1, kTeamReadyRoom, kNeutralTeamType, msg), true)
    Shared.Message("Chat All - " .. "Overview" .. ": " .. msg)
    Server.AddChatToHistory(msg, "Overview", 0, kTeamReadyRoom, false)
end

class 'Overview'

function Overview:Initialize()
    uuid.seed()
    gameStateMonitor = GameStateMonitor()

    -- trackers
    generalTracker = GeneralTracker()

    -- insert trackers
    table.insert(trackers, generalTracker)

    delay = 1 / updatesPerSecond
    Event.Hook("UpdateServer", OnUpdateServer)
end

function Overview:GetGametime()
    return math.max( 0, math.floor(Shared.GetTime()) - GetGameInfoEntity():GetStartTime() )
end

function Overview:Reset()
    for _,tracker in ipairs(trackers) do
        tracker:OnReset()
    end
    self:InitHeader()
end

function Overview:InitHeader()
    header = {}
    header['round_id'] = uuid.new()
    header['map'] = Shared.GetMapName()
    header['start_time'] = os.date("%X")
    header['start_date'] = os.date("%x")

    -- init these but we need to set their values later in OnGameEnd. We can use these values to check if the data is complete.
    header['winning_team'] = -1
    header['round_length'] = -1
    header['end_time'] = -1
    header['end_date'] = -1
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
