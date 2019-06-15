StatsTracker = {}
StatsTracker.lastState = kGameState.NotStarted

function StatsTracker:Initialise()
    Overview:Print("Initialised")
end

function StatsTracker:CheckForRoundStart()
    local currentState = GetGamerules():GetGameState()

    if StatsTracker.lastState ~= currentState then
        if currentState == kGameState.Countdown then
            StatsTracker:OnCountdownStart()
        elseif currentState == kGameState.Started then
            StatsTracker:OnGameStart()
        end
    end

    StatsTracker.lastState = currentState
end

function StatsTracker:OnUpdate()
    if self.lastState ~= kGameState.Started then
        self:CheckForRoundStart()
        return
    end
end

function StatsTracker:OnGameStart()
    Overview:PrintDebug("Game started")
end

function StatsTracker:OnCountdownStart()
    Overview:PrintDebug("Countdown started")
end

local function OnUpdateServer()
    StatsTracker:OnUpdate()
end

-- apparently there's no event for the game starting soooooooooooooooooooooooo
Event.Hook("UpdateServer", OnUpdateServer)

-- init
StatsTracker:Initialise()
