StatsTracker = {}
local LibDeflate = Overview.Libraries:GetLibraryObject("LibDeflate")
local bot = 0

local lastTime = 0
local delay = Server.GetFrameRate() / 10

function StatsTracker:SetupTeamHandlers(team)
    team:AddListener("OnResearchComplete",
            function(structure, researchId)
                if not self.tracking then
                    return
                end

                local node = team:GetTechTree():GetTechNode(researchId)

                if node:GetIsResearch() or node:GetIsUpgrade() then
                    Overview.Logger:PrintDebug("RESEARCH: On " .. structure.kMapName .. " tech: " .. EnumToString(kTechId, node:GetTechId()))

                    local newResearch = {}
                    newResearch.timeCompleted = self:GetGametime()
                    newResearch.researchId = researchId
                    newResearch.researchName = EnumToString(kTechId, node:GetTechId())
                    newResearch.structure = structure.kMapName

                    local researchStats = self.stats['research']["team" .. team:GetTeamNumber()]

                    table.insert(researchStats, newResearch)
                end

            end )

    team:AddListener("OnCommanderAction",
            function(techId)
                if not self.tracking then
                    return
                end
                Overview.Logger:PrintDebug("COMMANDER ACTION " .. EnumToString(kTechId, techId))

                local newCommAction = {}
                newCommAction.timeCompleted = self:GetGametime()
                newCommAction.techId = researchId
                newCommAction.techName = EnumToString(kTechId, techId)

                local commActionStats = self.stats['commAction']["team" .. team:GetTeamNumber()]

                table.insert(commActionStats, newCommAction)
            end )

    team:AddListener("OnConstructionComplete",
            function(structure)
                if not self.tracking then
                    return
                end
                Overview.Logger:PrintDebug("CONSTRUCTION COMPLETE ".. structure.kMapName)

                local newConstruction = {}
                newConstruction.timeCompleted = self:GetGametime()
                newConstruction.structure = structure.kMapName

                local constructionStats = self.stats['construction']["team" .. team:GetTeamNumber()]

                table.insert(constructionStats, newConstruction)
            end )

    team:AddListener("OnEvolved",
            function(techId)
                if not self.tracking then
                    return
                end
                Overview.Logger:PrintDebug("Evolved: " .. EnumToString(kTechId, techId))

                local newEvolved = {}
                newEvolved.timeCompleted = self:GetGametime()
                newEvolved.techId = techId
                newEvolved.techName = EnumToString(kTechId, techId)

                local evolvedStats = self.stats['evolved']

                table.insert(evolvedStats, newEvolved)
            end )

    team:AddListener("OnBought",
            function(techId)
                if not self.tracking then
                    return
                end

                Overview.Logger:PrintDebug("BOUGHT " .. EnumToString(kTechId, techId))

                local newBought = {}
                newBought.timeCompleted = self:GetGametime()
                newBought.techId = techId
                newBought.techName = EnumToString(kTechId, techId)

                local boughtStats = self.stats['bought']

                table.insert(boughtStats, newBought)
            end )
end

function StatsTracker:InitTechStats()
    local stats = {'research', 'commAction', 'construction'}
    local teamStats = {'evolved', 'bought'}
    local team1 = "team" .. GetGamerules():GetTeam1():GetTeamNumber()
    local team2 = "team" .. GetGamerules():GetTeam2():GetTeamNumber()

    for _,v in pairs(stats) do
        self.stats[v] = {}
        self.stats[v][team1] = {}
        self.stats[v][team2] = {}
    end

    for _,v in pairs(teamStats) do
        self.stats[v] = {}
    end
end

function StatsTracker:Initialise()

    self.lastState = kGameState.NotStarted
    self.stats = {}
    self.tracking = false
    self.debug = false

    self:ResetStats()
    lastTime = Shared.GetTime()

    Overview.Logger:PrintDebug("Initialised")
end

function StatsTracker:ResetStats()
    self.stats = {}
    self.tracking = false
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

function StatsTracker:InitPlayerStats()
    local playerStats = {}

    for _, player in ientitylist(Shared.GetEntitiesWithClassname("PlayerInfoEntity")) do

        s = {}
        s['joined_at'] = 0
        s['left_at'] = -1
        s['playerName'] = player.playerName
        s['teamNumber'] = player.teamNumber

        if player.steamId ~= 0 then
            playerStats[player.steamId] = s
        else
            playerStats["bot" .. bot] = s
            bot = bot + 1
        end
    end

    self.stats['players'] = playerStats

    local commanders = {}

    commanders["team1"] = {}
    commanders['team2'] = {}

    self.stats['commanders'] = commanders
end

function StatsTracker:InitRoundStats()
    local roundStats = {}

    roundStats['start_time'] = os.date("%X")
    roundStats['start_date'] = os.date("%x")
    roundStats['map_name'] = Shared.GetMapName()

    self.stats['round'] = roundStats
end

function StatsTracker:OnGameStart()
    Overview.Logger:PrintDebug("Game started")
    self.tracking = true

    self:InitPlayerStats()
    self:InitRoundStats()
    self:InitTechStats()
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
    local playerStats = self.stats['players']
    for _, player in ientitylist(Shared.GetEntitiesWithClassname("PlayerInfoEntity")) do

        if player.steamId ~= 0 then -- don't include b0ts

            if playerStats[player.steamId] then

                s = playerStats[player.steamId]

                if player.teamNumber ~= s['teamNumber'] then
                    s['teamNumber'] = player.teamNumber
                end

                if player.playerName ~= s['playerName'] then
                    s['playerName'] = player.playerName
                end

                playerStats[player.steamId] = s
            end

        end
    end
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