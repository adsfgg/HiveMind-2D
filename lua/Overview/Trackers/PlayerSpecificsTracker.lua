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
        local team = player:GetTeamNumber()

        if team == KTeam1Index then
            print("i'm a marine")
        elseif team == kTeam2Index then
            local upgrades = 0

            for _, upgrade in ipairs(player:GetUpgrades()) do
                if techUpgradesBitmask[upgrade] then
                    upgrades = bit.bor(upgrades, techUpgradesBitmask[upgrade])
                end
            end

            local lifeform = ""
            local energy = player:GetEnergy()
        end
    end
end
