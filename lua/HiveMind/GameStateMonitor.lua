--[[
    Class to monitor the GameState.
]]

class 'GameStateMonitor'

local lastState

function GameStateMonitor:Init(hiveMind)
    self.hiveMind = assert(hiveMind)
end

function GameStateMonitor:CheckGameState()
    local currentState = GetGamerules():GetGameState()
    if not lastState then
        lastState = currentState
        return false
    end

    if lastState ~= kGameState.Started then
        self:CheckForGameStart(currentState)
    end

    self:CheckForGameEnd(currentState)

    lastState = currentState

    return currentState == kGameState.Started
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
    print("GameStateMonitor:OnCountdownStart()")
    self.hiveMind:OnCountdownStart()
end

function GameStateMonitor:OnGameStart()
    print("GameStateMonitor:OnGameStart()")
    self.hiveMind:OnGameStart()
end

function GameStateMonitor:OnGameEnd()
    print("GameStateMonitor:OnGameEnd()")
    self.hiveMind:OnGameEnd()
end
