--[[
    Here we track player specific info.

    Currently tracking:
    * Marines
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

local function GetMarineUpgrades(player)
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

    return upgrades
end

function PlayerSpecificsTracker:UpdateMarine(player, id)
    local upgrades = GetMarineUpgrades(player)
    local weapon = player:GetActiveWeapon()
    local ammo = false

    if weapon and weapon:isa("ClipWeapon") and weapon.GetAmmoFraction then
        ammo = weapon:GetAmmoFraction()
    end

    self:TryUpdateValue("upgrades", upgrades, id)
    self:TryUpdateValue("ammo", ammo, id)
end

function PlayerSpecificsTracker:UpdateAlien(player, id)
    local upgrades = 0

    for _, upgrade in ipairs(player:GetUpgrades()) do
        if techUpgradesBitmask[upgrade] then
            upgrades = bit.bor(upgrades, techUpgradesBitmask[upgrade])
        end
    end

    local lifeform = player:GetPlayerStatusDesc()
    lifeform = EnumToString(kPlayerStatus, lifeform)
    local energy

    if player.GetEnergyPercentage then
        energy = player:GetEnergyPercentage()
    else
        energy = false
    end

    self:TryUpdateValue("upgrades", upgrades, id)
    self:TryUpdateValue("lifeform", lifeform, id)
    self:TryUpdateValue("energy", energy, id)
end

function PlayerSpecificsTracker:OnUpdate()
    for _, player in ientitylist(Shared.GetEntitiesWithClassname("PlayerInfoEntity")) do
        local id = player:GetId()
        player = Shared.GetEntity(player.playerId)

        if player:isa("Marine") then
            self:UpdateMarine(player, id)
        elseif player:isa("Alien") then
            self:UpdateAlien(player, id)
        end
    end

    return Tracker.OnUpdate(self)
end
