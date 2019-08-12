StatsTracker = {}
local LibDeflate = Overview.Libraries:GetLibraryObject("LibDeflate")

local lastTime = 0
local delay = Server.GetFrameRate() / 10

function StatsTracker:Initialise()

    self.lastState = kGameState.NotStarted
    self.stats = {}
    self.debug = false

    self:ResetStats()

    Overview.Logger:PrintDebug("Initialised")
end

function StatsTracker:ResetStats()
    self.stats = {}
    self.tracking = false
    lastTime = Shared.GetTime()
end

function StatsTracker:CheckForRoundStart(currentState)
    if StatsTracker.lastState ~= currentState then
        if currentState == kGameState.Countdown then
            StatsTracker:OnCountdownStart()
        elseif currentState == kGameState.Started then
            StatsTracker:OnGameStart()
        end
    end
end

function StatsTracker:OnGameStart()
    Overview.Logger:PrintDebug("Game started")
    self.tracking = true
end

function StatsTracker:OnCountdownStart()
    Overview.Logger:PrintDebug("Countdown started")
    self:ResetStats()
    Overview.Logger:SendChatMessage('Recording overview demo')
end

function StatsTracker:SaveStats()
    local dataFile = io.open("config://RoundStats.json", "w+")
    local compressedDataFile = io.open("config://RoundStatsCompressed.txt", "w+")

    local jsonData = json.encode(self.stats, { indent=true })
    local compressedJsonData = LibDeflate:CompressDeflate(json.encode(self.stats, { indent=false }))

    if dataFile then
        dataFile:write(jsonData)
        io.close(dataFile)
    end

    if compressedDataFile then
        compressedDataFile:write(compressedJsonData)
        io.close(compressedDataFile)
    end
end

function StatsTracker:GetGametime()
    return math.max( 0, math.floor(Shared.GetTime()) - GetGameInfoEntity():GetStartTime() )
end

function StatsTracker:OnGameEnd(gamestate)
    if self.tracking == false then
        return
    end
    Overview.Logger:PrintDebug("Game ended")
    self.tracking = false

    self.stats['round']['end_time'] = os.date("%X")
    self.stats['round']['end_date'] = os.date("%x")
    self.stats['round']['round_length'] = self:GetGametime()
    local winning_team

    if gamestate == kGameState.Team1Won then
        winning_team = 1
    elseif gamestate == kGameState.Team2Won then
        winning_team = 2
    elseif gamestate == kGameState.Draw then
        winning_team = 0
    else
        winning_team = -1
    end

    self.stats['round']['winning_team'] = winning_team

    self:SaveStats()

    Overview.Logger:SendChatMessage('Demo saved.')
end

function StatsTracker:CheckForChanges()
    Overview.Logger:PrintDebug("Checking for changes")
end

function StatsTracker:OnUpdate()
    if lastTime + delay < Shared.GetTime() then
        lastTime = Shared.GetTime()

        local currentState = GetGamerules():GetGameState()
        local collectStats = true

        -- check game states

        -- check if the game is in countdown/starting
        if self.lastState ~= kGameState.Started then
            self:CheckForRoundStart(currentState)
            collectStats = false
        end

        -- check if the game is over
        if currentState ~= self.lastState and (currentState == kGameState.Team1Won or currentState == kGameState.Team2Won or currentState == kGameState.Draw) then
            self:OnGameEnd(currentState)
            collectStats = false
        end

        if not collectStats then
            StatsTracker.lastState = currentState
            return
        end

        -- gather stats
        self:CheckForChanges()
    end
end

local function OnUpdateServer()
    StatsTracker:OnUpdate()
end

-- apparently there's no event for the game starting soooooooooooooooooooooooo
Event.Hook("UpdateServer", OnUpdateServer)

-- init
StatsTracker:Initialise()