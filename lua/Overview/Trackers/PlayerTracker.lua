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

-- TODO: Add position and accuracy
function PlayerTracker:OnUpdate()
    -- iterate through all players
    for _, player in ientitylist(Shared.GetEntitiesWithClassname("PlayerInfoEntity")) do
        local id = player:GetId()
        player = Shared.GetEntity(player.playerId)
        local playerName = player:GetName()
        local pres = player:GetPersonalResources()
        local health = player:GetHealth()
        local armour = player:GetArmor()
        local team = player:GetTeamNumber()
        local alive = player:GetIsAlive()

        self:TryUpdateValue("player_name", playerName, id)
        self:TryUpdateValue("pres", pres, id)
        self:TryUpdateValue("health", health, id)
        self:TryUpdateValue("armour", armour, id)
        self:TryUpdateValue("team", team, id)
        self:TryUpdateValue("alive", alive, id)
    end

    return Tracker.OnUpdate(self)
end
