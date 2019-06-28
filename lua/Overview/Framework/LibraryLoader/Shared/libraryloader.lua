local Mod = GetMod()
local Libraries = {}
local kLibraryDir = "Libraries"
local libraryObjects = {}

function Libraries:GetLibraryPath(library)
    return string.format("lua/%s/%s/%s.lua", Mod:GetModName(), kLibraryDir, library)
end

function Libraries:LoadLibrary(library)
    Script.Load(self:GetLibraryPath(library))

    libraryObjects[library] = assert(GetLibraryObject, "Invalid library: " .. library)()
    GetLibraryObject = nil
end

function Libraries:LoadAllLibraries(libraries)
    for _, v in ipairs(libraries) do
        self:LoadLibrary(v)
    end
end

function Libraries:GetLibraryObject(library)
    return libraryObjects[library] or nil
end

function GetFrameworkModuleChanges()
    return "Libraries", Libraries
end
