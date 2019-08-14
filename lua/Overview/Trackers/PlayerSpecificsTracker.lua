--[[
    Here we track player specific info.

    Currently tracking:
    * Marines
        * equipment
        * ammo
        * upgrades
    * Aliens
        * upgrades
        * lifeform
        * energy
]]

class 'PlayerSpecificsTracker' (Tracker)

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

function PlayerSpecificsTracker:GetName()
    return "player_specifics"
end

function PlayerSpecificsTracker:OnUpdate()
    for _, player in ientitylist(Shared.GetEntitiesWithClassname("PlayerInfoEntity")) do
        local id = player:GetId()
        player = Shared.GetEntity(player.playerId)

        if player:isa("Marine") then
            local upgrades = 0

            if player:GetIsParasited() then
                upgrades = bit.bor(upgrades, techUpgradesBitmask[kTechId.Parasite])
            end

            if player:isa("JetpackMarine") then
                upgrades = bit.bor(upgrades, techUpgradesBitmask[kTechId.Jetpack])
            end

            --Mapname to TechId list of displayed weapons
            local displayWeapons = { { Welder.kMapName, kTechId.Welder },
                                     { ClusterGrenadeThrower.kMapName, kTechId.ClusterGrenade },
                                     { PulseGrenadeThrower.kMapName, kTechId.PulseGrenade },
                                     { GasGrenadeThrower.kMapName, kTechId.GasGrenade },
                                     { LayMines.kMapName, kTechId.Mine} }

            for _, weapon in ipairs(displayWeapons) do
                if player:GetWeapon(weapon[1]) ~= nil then
                    upgrades = bit.bor(upgrades, techUpgradesBitmask[weapon[2]])
                end
            end
        elseif player:isa("Alien") then
            local upgrades = 0

            for _, upgrade in ipairs(player:GetUpgrades()) do
                if techUpgradesBitmask[upgrade] then
                    upgrades = bit.bor(upgrades, techUpgradesBitmask[upgrade])
                end
            end

            local lifeform = ""
            local energy

            if player.GetEnergy then
                energy = player:GetEnergy()
            else
                energy = -1
            end

            self:TryUpdateValue("upgrades", upgrades, id)
            self:TryUpdateValue("lifeform", lifeform, id)
            self:TryUpdateValue("energy", energy, id)
        end
    end

    return Tracker.OnUpdate(self)
end
