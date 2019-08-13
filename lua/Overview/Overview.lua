if not Server then return end

Script.Load("lua/Overview/Trackers/GeneralTracker.lua")
Script.Load("lua/Overview/GameStateMonitor.lua")
Script.Load("lua/Overview/SaveSend.lua")
Script.Load("lua/Overview/uuid.lua")

local uuid = GetUUIDLibrary()

local gameStateMonitor
local lastTime = 0
local delay = Server.GetFrameRate() / 10

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


    Event.Hook("UpdateServer", OnUpdateServer)
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

function Overview:OnCountdownStart()
    self:Reset()
    lastTime = Shared.GetTime()
    SendChatMessage("Recording overview demo")
end

function Overview:OnGameStart()

end

function Overview:OnGameEnd()
    -- initialize the json structure
    jsonStructure = {}
    jsonStructure['header'] = header
    jsonStructure['update_data'] = update_data

    -- save the data locally then send it to the server.
    SaveAndSendRoundData(jsonStructure)

    -- notify the players that the demo was saved successfully.
    SendChatMessage("Demo saved. Round Id: " .. jsonStructure['header']['round_id'])
end
