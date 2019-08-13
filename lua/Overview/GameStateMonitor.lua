--[[
    Class to monitor the GameState.
]]

class 'GameStateMonitor'

local lastState

function GameStateMonitor:CheckGameState()
    local currentState = GetGamerules():GetGameState()
    if not lastState then
        lastState = currentState
        return
    end

    local collectStats = true

    if lastState ~= kGameState.Started then
        self:CheckForGameStart(currentState)
        collectStats = false
    end

    if self:CheckForGameEnd(currentState) then
        collectStats = false
    end

    lastState = currentState

    return collectStats
end

function GameStateMonitor:CheckForGameStart(currentState)
    if lastState ~= currentState then
        if currentState == kGameState.Countdown then
            self:OnCountdownStart()
        elseif currentState == kGameState.Started then
            self:OnGameStart()
        end
    end
end

function GameStateMonitor:CheckForGameEnd(currentState)
    if lastState ~= currentState then
        if currentState == kGameState.Team1Won or currentState == kGameState.Team2Won or currentState == kGameState.Draw then
            self:OnGameEnd()
            return true
        end
    end
    return false
end

function GameStateMonitor:OnCountdownStart()
    print("Overview: Countdown started.")
    Overview:OnCountdownStart()
end

function GameStateMonitor:OnGameStart()
    print("Overview: Game started")
    Overview:OnGameStart()
end

function GameStateMonitor:OnGameEnd()
    print("Overview: Game ended.")
    Overview:OnGameEnd()
end
