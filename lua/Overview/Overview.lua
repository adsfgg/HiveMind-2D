if not Server then return end

Script.Load("lua/Overview/Trackers/GeneralTracker.lua")
Script.Load("lua/Overview/GameStateMonitor.lua")
Script.Load("lua/Overview/LibDeflate.lua")

local LibDeflate = GetLibDeflate()

local gameStateMonitor
local lastTime = 0
local delay = Server.GetFrameRate() / 10

local function UpdateTrackers()
    print("Updating trackers...")
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
    gameStateMonitor = GameStart()

    Event.Hook("UpdateServer", OnUpdateServer)
end

function Overview:OnCountdownStart()
    SendChatMessage("Recording overview demo")
end

function Overview:OnGameStart()

end

function Overview:OnGameEnd()
    SendChatMessage("Demo saved.")
end