local ModConfig = {}

local configOptions = {}
local defaultConfigOptions = {}

function ModConfig:GetConfigFileName()
    local modName = self:GetModName()

    if Server then
        return modName .. "_Server.json"
    end

    return modName .. ".json"
end

function ModConfig:RegisterConfigOption(name, value)
    assert(not configOptions[name], string.format("RegisterConfigOption: %q is already registered", name))
    defaultConfigOptions[name] = value
end

function ModConfig:GetDefaultConfigOptions()
    return defaultConfigOptions
end

function ModConfig:GetConfigOption(name)
    assert(configOptions[name], string.format("GetConfigOption: No config option with the name %q is registered", name))
    return configOptions[name]
end

function ModConfig:UpdateConfigOption(name, value)
    assert(configOptions[name], string.format("UpdateConfigOption: No config option with the name %q is registered", name))
    configOptions[name] = value
    self:SaveConfigOptions()
end

function ModConfig:SaveConfigOptions()
    SaveConfigFile(self:GetConfigFileName(), configOptions)
end

function ModConfig:LoadConfig()
    configOptions = LoadConfigFile(self:GetConfigFileName()) or defaultConfigOptions
end

function GetFrameworkModuleChanges()
    return "ModConfig", ModConfig
end