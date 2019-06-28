local Mod = GetMod()

local kTechIdToMaterialOffset = debug.getupvaluex( GetMaterialXYOffset,   "kTechIdToMaterialOffset" )
local additions = Mod.Tech:GetTechIdToMaterialOffsetAdditions()

for _,v in ipairs(additions) do
    Mod.Logger:PrintDebug("Adding kTechIdToMaterialOffset for: " .. (EnumToString(kTechId, v[1]) or v[1]), "all")
    kTechIdToMaterialOffset[v[1]] = v[2]
end
