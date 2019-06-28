local Mod = GetMod()
local Tech = Mod.Tech

local function TechDataChanges(techData)
  local techToRemove = Tech:GetTechToRemove()
  local techToChange = Tech:GetTechToChange()

  for techIndex = #techData, 1, -1 do
    local record = techData[techIndex]
    local techDataId = record[kTechDataId]

    if techToRemove[techDataId] then
      Mod.Logger:PrintDebug("Removing tech: " .. record[kTechDataDisplayName], "all")
      table.remove(techData, techIndex)
    elseif techToChange[techDataId] then
      Mod.Logger:PrintDebug("Changing tech: " .. record[kTechDataDisplayName], "all")

      for index, value in pairs(techToChange[techDataId]) do
        techData[techIndex][index] = value
      end
    end
  end
end

local oldBuildTechData = BuildTechData
function BuildTechData()
  local techData = oldBuildTechData()

  TechDataChanges(techData)

  local techToAdd = Tech:GetTechToAdd()
  for _,v in ipairs(techToAdd) do
    Mod.Logger:PrintDebug("Adding tech: " .. v[kTechDataDisplayName])
    table.insert(techData, v)
  end

  return techData
end
