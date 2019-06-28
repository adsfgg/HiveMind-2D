local Mod = GetMod()

local function LoadSharedFiles(module, p)
    local path = Mod:FormatDir("Framework/" .. module, "Shared")

    local SharedFiles = {}
    Shared.GetMatchingFileNames(path, true, SharedFiles)

    for j = 1, #SharedFiles do
        p(string.format("Loading shared file: %s", SharedFiles[j]))
        Script.Load(SharedFiles[j])
        if GetFrameworkModuleChanges then
            local name, value = GetFrameworkModuleChanges()
            GetFrameworkModuleChanges = nil
            local valid, reason = Mod:ValidateModule(name, value)

            if valid then
                p(string.format("Integrating module: %s", name))
                Mod[name] = value
            else
                p(string.format("Not integrating module %s: %s", name, reason))
            end
        end
    end
end

local function SetupFileHooks(module, p)
    local currentModule = "Framework/" .. module
    local types = { "Halt", "Post", "Pre", "Replace" }

    for j = 1, #types do
        local hookType = types[j]
        local path = Mod:FormatDir(currentModule, hookType)
        local files = {}

        Shared.GetMatchingFileNames(path, true, files)

        for k = 1, #files do
            local file = files[k]
            local vpath = file:gsub(Mod:GetModName() .. "/.*/" .. hookType .. "/", "")

            p(string.format("Hooking file: %s, Vanilla Path: %s, Method: %s", file, vpath, hookType), "all")
            ModLoader.SetupFileHook(vpath, file, hookType:lower())
        end
    end
end

local function LoadClientScripts(module, p)
    local path = Mod:FormatDir("Framework/" .. module, "Client")

    local ClientFiles = {}
    Shared.GetMatchingFileNames(path, true, ClientFiles)

    for j = 1, #ClientFiles do
        p(string.format("Loading client file: %s", ClientFiles[j]))
        Script.Load(ClientFiles[j])
    end
end

local function LoadServerScripts(module, p)
    local path = Mod:FormatDir("Framework/" .. module, "Server")

    local ServerFiles = {}
    Shared.GetMatchingFileNames(path, true, ServerFiles)

    for j = 1, #ServerFiles do
        p(string.format("Loading server file: %s", ServerFiles[j]))
        Script.Load(ServerFiles[j])
    end
end

local function LoadPredictScripts(module, p)
    local path = Mod:FormatDir("Framework/" .. module, "Predict")

    local PredictFiles = {}
    Shared.GetMatchingFileNames(path, true, PredictFiles)

    for j = 1, #PredictFiles do
        p("Loading predict file: %s", PredictFiles[j])
        Script.Load(PredictFiles[j])
    end
end

local function LoadFrameworkModule(module)
    local p

    -- logging might not have been setup at this point
    if Mod.Logger ~= nil then
        p = function(str) Mod.Logger:PrintDebug(str) end
    else
        local vm = Client and "Client" or Server and "Server" or Predict and "Predict" or "None"
        p =
        function(str)
            --print(string.format("[%s - %s] %s", kModName, vm, str))
        end
    end

    p("Loading framework module: " .. module)

    -- load shared
    LoadSharedFiles(module, p)

    -- setup filehooks
    SetupFileHooks(module, p)

    -- load individual vm scripts
    if Client then
        LoadClientScripts(module, p)
    elseif Server then
        LoadServerScripts(module, p)
    elseif Predict then
        LoadPredictScripts(module, p)
    end
end

function GetFrameworkModuleLoader()
    return LoadFrameworkModule
end