local ResourceSystem = {}

local guiTexturesToReplace = {}

function ResourceSystem:ReplaceGUITexture(old, new)
    assert(not guiTexturesToReplace[old], string.format("ReplaceGUITexture: The texture %q is already being replaced with %q.", old, guiTexturesToReplace[old]))
    guiTexturesToReplace[old] = new
end

function ResourceSystem:GetGUITexturesToReplace()
    return guiTexturesToReplace
end

function GetFrameworkModuleChanges()
    return "ResourceSystem", ResourceSystem
end