local Mod = GetMod()
local Tech = Mod.Tech

local upgradeToRemove = Tech:GetUpgradesToRemove()
local upgradeToChange = Tech:GetUpgradesToChange()

local oldAddUpgradeNode = TechTree.AddUpgradeNode
  function TechTree:AddUpgradeNode(techId, prereq1, prereq2)
  if upgradeToRemove[techId] then
    Mod.Logger:PrintDebug("Removing upgrade: " .. (EnumToString(kTechId, techId) or techId), "all")
    return
  elseif upgradeToChange[techId] then
    Mod.Logger:PrintDebug("Changing upgrade: " .. (EnumToString(kTechId, techId) or techId), "all")
    local newNode = upgradeToChange[techId]

    oldAddUpgradeNode(self, newNode[1], newNode[2], newNode[3])
  else
    oldAddUpgradeNode(self, techId, prereq1, prereq2)
  end
end

local researchToRemove = Tech:GetResearchToRemove()
local researchToChange = Tech:GetResearchToChange()

local oldAddResearchNode = TechTree.AddResearchNode
function TechTree:AddResearchNode(techId, prereq1, prereq2, addOnTechId)
  if researchToRemove[techId] then
    Mod.Logger:PrintDebug("Removing research node: " .. (EnumToString(kTechId, techId) or techId), "all")
  elseif researchToChange[techId] then
    Mod.Logger:PrintDebug("Changing research node: " .. (EnumToString(kTechId, techId) or techId), "all")
    local changedNode = researchToChange[techId]

    oldAddResearchNode(self, changedNode[1], changedNode[2], changedNode[3], changedNode[4])
  else
    oldAddResearchNode(self, techId, prereq1, prereq2, addOnTechId)
  end
end

local targetedActivationToRemove = Tech:GetTargetedActivationToRemove()
local targetedActivationToChange = Tech:GetTargetedActivationToChange()

local oldAddTargetedActivation = TechTree.AddTargetedActivation
function TechTree:AddTargetedActivation(techId, prereq1, prereq2)
  if targetedActivationToRemove[techId] then
    Mod.Logger:PrintDebug("Removing targeted activation: " .. (EnumToString(kTechId, techId) or techId), "all")
    return
  elseif targetedActivationToChange[techId] then
    Mod.Logger:PrintDebug("Changing targeted activation: " .. (EnumToString(kTechId, techId) or techId), "all")
    local changedNode = targetedActivationToChange[techId]

    oldAddTargetedActivation(self, changedNode[1], changedNode[2], changedNode[3])
  else
    oldAddTargetedActivation(self, techId, prereq1, prereq2)
  end
end

local buyToRemove = Tech:GetBuyNodesToRemove()
local buyToChange = Tech:GetBuyNodesToChange()

local oldAddBuyNode = TechTree.AddBuyNode
function TechTree:AddBuyNode(techId, prereq1, prereq2, addOnTechId)
  if buyToRemove[techId] then
    Mod.Logger:PrintDebug("Removing buy node: " .. (EnumToString(kTechId, techId) or techId), "all")
    return
  elseif buyToChange[techId] then
    Mod.Logger:PrintDebug("Changing buy node: " .. (EnumToString(kTechId, techId) or techId), "all")
    local changedNode = buyToChange[techId]

    oldAddBuyNode(self, changedNode[1], changedNode[2], changedNode[3], changedNode[4])
  else
    oldAddBuyNode(self, techId, prereq1, prereq2, addOnTechId)
  end
end

local buildToRemove = Tech:GetBuildNodesToRemove()
local buildToChange = Tech:GetBuildNodesToChange()

local oldAddBuildNode = TechTree.AddBuildNode
function TechTree:AddBuildNode(techId, prereq1, prereq2, isRequired)
  if buildToRemove[techId] then
    Mod.Logger:PrintDebug("Removing build node: " .. (EnumToString(kTechId, techId) or techId), "all")
    return
  elseif buildToChange[techId] then
    Mod.Logger:PrintDebug("Changing build node: " .. (EnumToString(kTechId, techId) or techId), "all")
    local changedNode = buildToChange[techId]

    oldAddBuildNode(self, changedNode[1], changedNode[2], changedNode[3], changedNode[4])
  else
    oldAddBuildNode(self, techId, prereq1, prereq2, isRequired)
  end
end

local passiveToRemove = Tech:GetPassiveToRemove()
local passiveToChange = Tech:GetPassiveToChange()

local oldAddPassive = TechTree.AddPassive
function TechTree:AddPassive(techId, prereq1, prereq2)
  if passiveToRemove[techId] then
    Mod.Logger:PrintDebug("Removing passive: " .. (EnumToString(kTechId, techId) or techId), "all")
    return
  elseif passiveToChange[techId] then
    Mod.Logger:PrintDebug("Changing passive: " .. (EnumToString(kTechId, techId) or techId), "all")
    local changedNode = passiveToChange[techId]

    oldAddPassive(self, changedNode[1], changedNode[2], changedNode[3])
  else
    oldAddPassive(self, techId, prereq1, prereq2)
  end
end

local specialToRemove = Tech:GetSpecialToRemove()
local specialToChange = Tech:GetSpecialToChange()

local oldAddSpecial = TechTree.AddSpecial
function TechTree:AddSpecial(techId, prereq1, prereq2, requiresTarget)
  if specialToRemove[techId] then
    Mod.Logger:PrintDebug("Removing special: " .. (EnumToString(kTechId, techId) or techId), "all")
    return
  elseif specialToChange[techId] then
    Mod.Logger:PrintDebug("Changing special: " .. (EnumToString(kTechId, techId) or techId), "all")
    local changedNode = specialToChange[techId]

    oldAddSpecial(self, changedNode[1], changedNode[2], changedNode[3], changedNode[4])
  else
    oldAddSpecial(self, techId, prereq1, prereq2, requiresTarget)
  end
end

local manufactureNodesToRemove = Tech:GetManufactureNodesToRemove()
local manufactureNodesToChange = Tech:GetManufactureNodesToChange()

local oldAddManufactureNode = TechTree.AddManufactureNode
function TechTree:AddManufactureNode(techId, prereq1, prereq2, isRequired)
  if manufactureNodesToRemove[techId] then
    Mod.Logger:PrintDebug("Removing manufacture node: " .. (EnumToString(kTechId, techId) or techId), "all")
    return
  elseif manufactureNodesToChange[techId] then
    Mod.Logger:PrintDebug("Changing manufacture node: " .. (EnumToString(kTechId, techId) or techId), "all")
    local changedNode = manufactureNodesToChange[techId]

    oldAddManufactureNode(self, changedNode[1], changedNode[2], changedNode[3], changedNode[4])
  else
    oldAddManufactureNode(self, techId, prereq1, prereq2, isRequired)
  end
end

local ordersToRemove = Tech:GetOrdersToRemove()

local oldAddOrder = TechTree.AddOrder
function TechTree:AddOrder(techId)
  if ordersToRemove[techId] then
    Mod.Logger:PrintDebug("Removing order: " .. (EnumToString(kTechId, techId) or techId), "all")
    return
  else
    oldAddOrder(self, techId)
  end
end

local activationToRemove = Tech:GetActivationToRemove()
local activationToChange = Tech:GetActivationToChange()

local oldAddActivation = TechTree.AddActivation
function TechTree:AddActivation(techId, prereq1, prereq2)
  if activationToRemove[techId] then
    Mod.Logger:PrintDebug("Removing activation: " .. (EnumToString(kTechId, techId) or techId), "all")
    return
  elseif activationToChange[techId] then
    Mod.Logger:PrintDebug("Changing activation: " .. (EnumToString(kTechId, techId) or techId), "all")
    local changedNode = activationToChange[techId]

    oldAddActivation(self, changedNode[1], changedNode[2], changedNode[3])
  else
    oldAddActivation(self, techId, prereq1, prereq2)
  end
end

local targetedBuyToRemove = Tech:GetTargetedBuyToRemove()
local targetedBuyToChange = Tech:GetTargetedBuyToChange()

local oldAddTargetedBuyNode = TechTree.AddTargetedBuyNode
function TechTree:AddTargetedBuyNode(techId, prereq1, prereq2, addOnTechId)
  if targetedBuyToRemove[techId] then
    Mod.Logger:PrintDebug("Removing targeted buy node: " .. (EnumToString(kTechId, techId) or techId), "all")
    return
  elseif targetedBuyToChange[techId] then
    Mod.Logger:PrintDebug("Changing targeted buy node: " .. (EnumToString(kTechId, techId) or techId), "all")
    local changedNode = targetedBuyToChange[techId]

    oldAddTargetedBuyNode(self, changedNode[1], changedNode[2], changedNode[3], changedNode[4])
  else
    oldAddTargetedBuyNode(self, techId, prereq1, prereq2, addOnTechId)
  end
end
