class 'GameStart'

local lastState

function GameStart:CheckGameState()
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

function GameStart:CheckForGameStart(currentState)
    if lastState ~= currentState then
        if currentState == kGameState.Countdown then
            self:OnCountdownStart()
        elseif currentState == kGameState.Started then
            self:OnGameStart()
        end
    end
end

function GameStart:CheckForGameEnd(currentState)
    if lastState ~= currentState then
        if currentState == kGameState.Team1Won or currentState == kGameState.Team2Won or currentState == kGameState.Draw then
            self:OnGameEnd()
            return true
        end
    end
    return false
end

function GameStart:OnCountdownStart()
    print("Overview: Countdown started.")
    Overview:OnCountdownStart()
end

function GameStart:OnGameStart()
    print("Overview: Game started")
    Overview:OnGameStart()
end

function GameStart:OnGameEnd()
    print("Overview: Game ended.")
    Overview:OnGameEnd()
end
