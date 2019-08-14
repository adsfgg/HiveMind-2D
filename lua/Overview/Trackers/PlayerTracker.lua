--[[
    Here we track information about players.

    Currently tracks:
    * id
    * playername
    * pres
    * Health
    * armour
    * position on map
    * direction
]]

Script.Load("lua/Overview/Trackers/Tracker.lua")

class 'PlayerTracker' (Tracker)

function PlayerTracker:GetName()
    return "player"
end

function PlayerTracker:OnUpdate()
    -- iterate through all players
    for _, player in ientitylist(Shared.GetEntitiesWithClassname("PlayerInfoEntity")) do
        local id = player:GetId()
        player = Shared.GetEntity(player.playerId)
        local team = player:GetTeamNumber()

        if team ~= kTeamReadyRoom then
            local playerName = player:GetName()
            local pres = player:GetPersonalResources()
            local health = player:GetHealth()
            local armour = player:GetArmor()
            local alive = player:GetIsAlive()
            local commander = player:isa("Commander")
            local current_weapon = false
            local weapon = player:GetActiveWeapon()
            local spectator = player:GetIsSpectator()
            local position = player:GetPositionForMinimap()
            local direction = player:GetDirectionForMinimap()

            if weapon and weapon.GetMapName then
                current_weapon = weapon:GetMapName()
            end

            self:TryUpdateValue("player_name", playerName, id)
            self:TryUpdateValue("pres", pres, id)
            self:TryUpdateValue("health", health, id)
            self:TryUpdateValue("armour", armour, id)
            self:TryUpdateValue("team", team, id)
            self:TryUpdateValue("alive", alive, id)
            self:TryUpdateValue("commander", commander, id)
            self:TryUpdateValue("spectator", spectator, id)
            self:TryUpdateValue("current_weapon", current_weapon, id)
            if not spectator then
                self:TryUpdateValue("position_x", position.x, id)
                self:TryUpdateValue("position_z", position.z, id)
                self:TryUpdateValue("direction", direction, id)
            end
        end
    end

    return Tracker.OnUpdate(self)
end
