if Server then
    local oldOnCreate = NS2Gamerules.OnCreate
    function NS2Gamerules:OnCreate()
        oldOnCreate(self)
        StatsTracker:SetupTeamHandlers(self.team1)
        StatsTracker:SetupTeamHandlers(self.team2)
    end
end