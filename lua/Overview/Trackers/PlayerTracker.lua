--[[
    Here we track information about players.

    Currently tracks:
    * id
    * playername
    * pres
    * Health
    * armour
    * position on map
    * accuracy
]]

Script.Load("lua/Overview/Trackers/Tracker.lua")

class 'PlayerTracker' (Tracker)

function PlayerTracker:GetName()
    return "player"
end

local techUpgradesTable =
{
    kTechId.Jetpack,
    kTechId.Welder,
    kTechId.ClusterGrenade,
    kTechId.PulseGrenade,
    kTechId.GasGrenade,
    kTechId.Mine,

    kTechId.Vampirism,
    kTechId.Carapace,
    kTechId.Regeneration,

    kTechId.Aura,
    kTechId.Focus,
    kTechId.Camouflage,

    kTechId.Celerity,
    kTechId.Adrenaline,
    kTechId.Crush,

    kTechId.Parasite
}

local techUpgradesBitmask = CreateBitMask(techUpgradesTable)

-- TODO: Add position and accuracy
function PlayerTracker:OnUpdate()
    -- iterate through all players
    for _, player in ientitylist(Shared.GetEntitiesWithClassname("PlayerInfoEntity")) do
        player = Shared.GetEntity(player.playerId)
        local id = player:GetId()
        local playerName = player:GetName()
        local pres = player:GetPersonalResources()
        local health = player:GetHealth()
        local armour = player:GetArmor()
        local team = player:GetTeamNumber()

        self:TryUpdateValue("player_name", playerName, id)
        self:TryUpdateValue("pres", pres, id)
        self:TryUpdateValue("health", health, id)
        self:TryUpdateValue("armour", armour, id)
        self:TryUpdateValue("team", team, id)
    end

    return Tracker.OnUpdate(self)
end

--[[

players[general[pres, team, etc], [specific] ]

]]