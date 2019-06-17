StatsTracker = {}
StatsTracker.lastState = kGameState.NotStarted
StatsTracker.stats = {}

function StatsTracker:Initialise()
    Overview:Print("Initialised")
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

function StatsTracker:ResetStats()
    self.stats = {}
end

function StatsTracker:OnGameStart()
    Overview:PrintDebug("Game started")

    -- init some player stats

    local playerStats = {}

    for _, player in ientitylist(Shared.GetEntitiesWithClassname("PlayerInfoEntity")) do

        if player.steamId ~= 0 then -- don't include b0ts

            s = {}
            s['joined_at'] = 0
            s['left_at'] = -1
            s['playerName'] = player.playerName
            s['teamNumber'] = player.teamNumber

            playerStats[player.steamId] = s

        end
    end

    self.stats['players'] = playerStats

    -- init some round stats
    local roundStats = {}

    roundStats['start_time'] = os.date("%X")
    roundStats['start_date'] = os.date("%x")
    roundStats['map_name'] = Shared.GetMapName()

    self.stats['round'] = roundStats
end

function StatsTracker:SendMessage(msg)
    Server.SendNetworkMessage("Chat", BuildChatMessage(false, "Overview", -1, kTeamReadyRoom, kNeutralTeamType, msg), true)
    Shared.Message("Chat All - Overview: " .. msg)
    Server.AddChatToHistory(msg, "Overview", 0, kTeamReadyRoom, false)
end

function StatsTracker:OnCountdownStart()
    Overview:PrintDebug("Countdown started")
    self:ResetStats()
    self:SendMessage('Recording overview demo')
end

function StatsTracker:SaveStats()
    local dataFile = io.open("config://RoundStats.json", "w+")

    local jsonData = json.encode(self.stats, { indent=true })

    if dataFile then
        dataFile:write(jsonData)
        io.close(dataFile)
    end
end

function StatsTracker:OnGameEnd(gamestate)
    Overview:PrintDebug("Game ended")

    self.stats['round']['end_time'] = os.date("%X")
    self.stats['round']['end_date'] = os.date("%x")
    self.stats['round']['round_length'] = math.max( 0, math.floor(Shared.GetTime()) - GetGameInfoEntity():GetStartTime() )
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

    self:SendMessage('Demo saved.')
end

function StatsTracker:CheckForChanges()

end

function StatsTracker:OnUpdate()
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

local function OnUpdateServer()
    StatsTracker:OnUpdate()
end

-- apparently there's no event for the game starting soooooooooooooooooooooooo
Event.Hook("UpdateServer", OnUpdateServer)

-- init
StatsTracker:Initialise()
