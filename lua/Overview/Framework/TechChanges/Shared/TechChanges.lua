local Mod = GetMod()
local Tech = {}

-- TODO: funcs to add tech
-- TODO: Make tech tree changes automatic

local kTechIdToMaterialOffsetAdditions = {}

function Tech:AddTechIdToMaterialOffset(techId, offset)
    table.insert(kTechIdToMaterialOffsetAdditions, {techId, offset})
end

-- alien techmap
local kAlienTechmapTechToChange = {}
local kAlienTechmapTechToAdd = {}
local kAlienTechmapTechToRemove = {}

local kAlienTechmapLinesToChange = {}
local kAlienTechmapLinesToAdd = {}
local kAlienTechmapLinesToRemove = {}

function Tech:ChangeAlienTechmapTech(techId, x, y)
    table.insert(kAlienTechmapTechToChange, techId, { techId, x, y } )
end

function Tech:AddAlienTechmapTech(techId, x, y)
    table.insert(kAlienTechmapTechToAdd, techId, { techId, x, y } )
end

function Tech:DeleteAlienTechmapTech(techId)
    table.insert(kAlienTechmapTechToRemove, techId, true )
end

function Tech:ChangeAlienTechmapLine(oldLine, newLine)
    table.insert(kAlienTechmapLinesToChange, { oldLine, newLine } )
end

function Tech:AddAlienTechmapLine(newLine)
    table.insert(kAlienTechmapLinesToAdd, { newLine } )
end

function Tech:DeleteAlienTechmapLine(line)
    table.insert(kAlienTechmapLinesToRemove, line )
end

-- marine techmap
local kMarineTechmapTechToChange = {}
local kMarineTechmapTechToAdd = {}
local kMarineTechmapTechToRemove = {}

local kMarineTechmapLinesToChange = {}
local kMarineTechmapLinesToAdd = {}
local kMarineTechmapLinesToRemove = {}

function Tech:ChangeMarineTechmapTech(techId, x, y)
    table.insert(kMarineTechmapTechToChange, techId, { techId, x, y } )
end

function Tech:AddMarineTechmapTech(techId, x, y)
    table.insert(kMarineTechmapTechToAdd, techId, { techId, x, y } )
end

function Tech:DeleteMarineTechmapTech(techId)
    table.insert(kMarineTechmapTechToRemove, techId, true )
end

function Tech:ChangeMarineTechmapLine(oldLine, newLine)
    table.insert(kMarineTechmapLinesToChange, { oldLine, newLine } )
end

function Tech:AddMarineTechmapLine(newLine)
    table.insert(kMarineTechmapLinesToAdd, { 0, newLine } )
end

function Tech:AddMarineTechmapLineWithTech(tech1, tech2)
    table.insert(kMarineTechmapLinesToAdd, { 1, tech1, tech2 })
end

function Tech:DeleteMarineTechmapLine(line)
    table.insert(kMarineTechmapLinesToRemove, { 0, line } )
end

function Tech:DeleteMarineTechmapLineWithTech(tech1, tech2)
    table.insert(kMarineTechmapLinesToRemove, { 1, tech1, tech2 } )
end

-- tech data changes
local kTechToRemove = {}
local kTechToChange = {}
local kTechToAdd = {}

function Tech:RemoveTech(techId)
    table.insert(kTechToRemove, techId, true )
end

function Tech:ChangeTech(techId, newTechData)
    table.insert(kTechToChange, techId, newTechData )
end

function Tech:AddTech(techData)
    table.insert(kTechToAdd, techData)
end

-- upgrade nodes
local kUpgradesToRemove = {}
local kUpgradesToChange = {}
local kUpgradesToAdd    = {}

function Tech:RemoveUpgrade(techId)
    table.insert(kUpgradesToRemove, techId, true)
end

function Tech:ChangeUpgrade(techId, prereq1, prereq2)
    table.insert(kUpgradesToChange, techId, { techId, prereq1, prereq2 } )
end

function Tech:AddUpgradeNode(techId, prereq1, prereq2, team)
    table.insert(kUpgradesToAdd, {techId, prereq1, prereq2, team})
end

-- research nodes
local kResearchToRemove = {}
local kResearchToChange = {}
local kResearchToAdd = {}

function Tech:RemoveResearch(techId)
    table.insert(kResearchToRemove, techId, true)
end

function Tech:ChangeResearch(techId, prereq1, prereq2, addOnTechId)
    table.insert(kResearchToChange, techId, { techId, prereq1, prereq2, addOnTechId } )
end

function Tech:AddResearchNode(techId, prereq1, prereq2, addOnTechId)
    table.insert(kResearchToAdd, { techId, prereq1, prereq2, addOnTechId } )
end

-- targeted activation
local kTargetedActivationToRemove = {}
local kTargetedActivationToChange = {}

function Tech:RemoveTargetedActivation(techId)
    table.insert(kTargetedActivationToRemove, techId, true)
end

function Tech:ChangeTargetedActivation(techId, prereq1, prereq2)
    table.insert(kTargetedActivationToChange, techId, { techId, prereq1, prereq2 } )
end

-- buy nodes
local kBuyToRemove = {}
local kBuyToChange = {}
local kBuyToAdd = {}

function Tech:RemoveBuyNode(techId)
    table.insert(kBuyToRemove, techId, true)
end

function Tech:ChangeBuyNode(techId, prereq1, prereq2, addOnTechId)
    table.insert(kBuyToChange, techId, { techId, prereq1, prereq2, addOnTechId } )
end

function Tech:AddBuyNode(techId, prereq1, prereq2, addOnTechId)
    table.insert(kBuyToAdd, { techId, prereq1, prereq2, addOnTechId } )
end

-- build nodes
local kBuildToRemove = {}
local kBuildToChange = {}
local kBuildToAdd = {}

function Tech:RemoveBuildNode(techId)
    table.insert(kBuildToRemove, techId, true)
end

function Tech:ChangeBuildNode(techId, prereq1, prereq2, isRequired)
    table.insert(kBuildToChange, techId, { techId, prereq1, prereq2, isRequired } )
end

function Tech:AddBuildNode(techId, prereq1, prereq2, isRequired)
    table.insert(kBuildToAdd, { techId, prereq1, prereq2, isRequired })
end

-- passive
local kPassiveToRemove = {}
local kPassiveToChange = {}

function Tech:RemovePassive(techId)
    table.insert(kPassiveToRemove, techId, true)
end

function Tech:ChangePassive(techId, prereq1, prereq2)
    table.insert(kPassiveToChange, techId, { techId, prereq1, prereq2 } )
end

-- special
local kSpecialToRemove = {}
local kSpecialToChange = {}

function Tech:RemoveSpecial(techId)
    table.insert(kSpecialToRemove, techId, true)
end

function Tech:ChangeSpecial(techId, prereq1, prereq2, requiresTarget)
    table.insert(kSpecialToChange, techId, { techId, prereq1, prereq2, requiresTarget } )
end

-- manufacture node
local kManufactureNodeToRemove = {}
local kManufactureNodeToChange = {}

function Tech:RemoveManufactureNode(techId)
    table.insert(kManufactureNodeToRemove, techId, true)
end

function Tech:ChangeManufactureNode(techId, prereq1, prereq2, isRequired)
    table.insert(kManufactureNodeToChange, techId, { techId, prereq1, prereq2, isRequired } )
end

-- orders
local kOrderToRemove = {}

function Tech:RemoveOrder(techId)
    table.insert(kOrderToRemove, techId, true)
end

-- activation
local kActivationToRemove= {}
local kActivationToChange = {}
local kActivationToAdd = {}

function Tech:RemoveActivation(techId)
    table.insert(kActivationToRemove, techId, true)
end

function Tech:ChangeActivation(techId, prereq1, prereq2)
    table.insert(kActivationToChange, techId, { techId, prereq1, prereq2 } )
end

function Tech:AddActivation(techId, prereq1, prereq2)
    table.insert(kActivationToAdd, { techId, prereq1, prereq2 } )
end

-- Targeted Buy Node
local kTargetedBuyToRemove = {}
local kTargetedBuyToChange = {}

function Tech:RemoveTargetedBuy(techId)
    table.insert(kTargetedBuyToRemove, techId, true)
end

function Tech:ChangeTargetedBuy(techId, prereq1, prereq2, addOnTechId)
    table.insert(kTargetedBuyToChange, techId, { techId, prereq1, prereq2, addOnTechId } )
end

-- getters BOOOOO

function Tech:GetTechIdsToAdd()
    return Mod:GetConfig().techIdsToAdd
end

function Tech:GetBindingAdditions()
    return bindingAdditions
end

function Tech:GetFrameworkVersion()
    return framework_version
end

function Tech:GetFrameworkBuild()
    return framework_build
end

function Tech:GetFrameworkVersionPrintable()
    return string.format("v%s.%s", self:GetFrameworkVersion(), self:GetFrameworkBuild())
end

function Tech:GetTechIdToMaterialOffsetAdditions()
    return kTechIdToMaterialOffsetAdditions
end

function Tech:GetAlienTechMapChanges()
    return kAlienTechmapTechToChange
end

function Tech:GetAlienTechMapAdditions()
    return kAlienTechmapTechToAdd
end

function Tech:GetAlienTechMapDeletions()
    return kAlienTechmapTechToRemove
end

function Tech:GetAlienTechMapLineChanges()
    return kAlienTechmapLinesToChange
end

function Tech:GetAlienTechMapLineAdditions()
    return kAlienTechmapLinesToAdd
end

function Tech:GetAlienTechMapLineDeletions()
    return kAlienTechmapLinesToRemove
end

function Tech:GetMarineTechMapChanges()
    return kMarineTechmapTechToChange
end

function Tech:GetMarineTechMapAdditions()
    return kMarineTechmapTechToAdd
end

function Tech:GetMarineTechMapDeletions()
    return kMarineTechmapTechToRemove
end

function Tech:GetMarineTechMapLineChanges()
    return kMarineTechmapLinesToChange
end

function Tech:GetMarineTechMapLineAdditions()
    return kMarineTechmapLinesToAdd
end

function Tech:GetMarineTechMapLineDeletions()
    return kMarineTechmapLinesToRemove
end

function Tech:GetTechToRemove()
    return kTechToRemove
end

function Tech:GetTechToChange()
    return kTechToChange
end

function Tech:GetTechToAdd()
    return kTechToAdd
end

function Tech:GetUpgradesToRemove()
    return kUpgradesToRemove
end

function Tech:GetUpgradesToChange()
    return kUpgradesToChange
end

function Tech:GetUpgradesToAdd()
    return kUpgradesToAdd
end

function Tech:GetResearchToRemove()
    return kResearchToRemove
end

function Tech:GetResearchToChange()
    return kResearchToChange
end

function Tech:GetResearchToAdd()
    return kResearchToAdd
end

function Tech:GetTargetedActivationToRemove()
    return kTargetedActivationToRemove
end

function Tech:GetTargetedActivationToChange()
    return kTargetedActivationToChange
end

function Tech:GetBuyNodesToRemove()
    return kBuyToRemove
end

function Tech:GetBuyNodesToChange()
    return kBuyToChange
end

function Tech:GetBuyNodesToAdd()
    return kBuyToAdd
end

function Tech:GetBuildNodesToRemove()
    return kBuildToRemove
end

function Tech:GetBuildNodesToChange()
    return kBuildToChange
end

function Tech:GetBuildNodesToAdd()
    return kBuildToAdd
end

function Tech:GetPassiveToRemove()
    return kPassiveToRemove
end

function Tech:GetPassiveToChange()
    return kPassiveToChange
end

function Tech:GetSpecialToRemove()
    return kSpecialToRemove
end

function Tech:GetSpecialToChange()
    return kSpecialToChange
end

function Tech:GetManufactureNodesToRemove()
    return kManufactureNodeToRemove
end

function Tech:GetManufactureNodesToChange()
    return kManufactureNodeToChange
end

function Tech:GetOrdersToRemove()
    return kOrderToRemove
end

function Tech:GetActivationToRemove()
    return kActivationToRemove
end

function Tech:GetActivationToChange()
    return kActivationToChange
end

function Tech:GetActivationToAdd()
    return kActivationToAdd
end

function Tech:GetTargetedBuyToRemove()
    return kTargetedBuyToRemove
end

function Tech:GetTargetedBuyToChange()
    return kTargetedBuyToChange
end

function GetFrameworkModuleChanges()
    return "Tech", Tech
end