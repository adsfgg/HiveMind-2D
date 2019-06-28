local Mod = GetMod()
local texturesToReplace = Mod.ResourceSystem:GetGUITexturesToReplace()

local old = GUIItem.SetTexture
function GUIItem:SetTexture(tex)
  if texturesToReplace[tex] then
    return old(self, texturesToReplace[tex])
  end

  return old(self, tex)
end
