--[[
    Here we track alien team things each tick

    Currently tracks:
    * tres
    * structures
    * tech
]]

Script.Load("lua/Overview/Trackers/Tracker.lua")

class 'TeamTracker' (Tracker)

function TeamTracker:GetName()
    return "team"
end

local function BuildStructures(self, team, teamIndex)
    local structures = {}

    return structures
end

local function BuildTech(self, team, teamIndex)
    local tech = {}

    return tech
end

local function UpdateTeam(self, team, teamIndex)
    local tres = team:GetTeamResources()
    local structures = BuildStructures(self, team, teamIndex)
    local tech = BuildTech(self, team, teamIndex)

    self:TryUpdateValue("tres", tres, teamIndex)
    self:TryUpdateValue("structures", structures, teamIndex)
    self:TryUpdateValue("tech", tech, teamIndex)
end

function TeamTracker:OnUpdate()
    local team = GetGamerules():GetTeam(kTeam1Index)
    UpdateTeam(self, team, tostring(kTeam1Index))

    team = GetGamerules():GetTeam(kTeam2Index)
    UpdateTeam(self, team, tostring(kTeam2Index))

    return Tracker.OnUpdate(self)
end