local framework_version = "0.23.1-beta"

local Mod = {}
local kModName = ""
local frameworkModules = {
  "Versioning",
  "Utilities",
  "LibraryLoader",
  "Bindings",
  "ModConfig",
  "ConsistencyCheck",
  "ResourceSystem",
  "TechChanges",
}

local function FindModName()
  local modName = debug.getinfo(1, "S").source:gsub("@lua/", ""):gsub("/Framework/.*%.lua", "")
  assert(modName and type(modName) == "string", "Error finding mod name. Please report.")
  kModName = modName
  return modName
end

function GetMod()
  local name = FindModName()
  return _G[name] or Mod
end

function Mod:Initialise()
  kModName = FindModName()

  local current_vm = Client and "Client" or Server and "Server" or Predict and "Predict" or "Unknown"

  Shared.Message(string.format("[%s - %s] Loading framework %s", kModName, current_vm, self:GetFrameworkVersion()))

  if _G[kModName] then
    Mod = _G[kModName]
    Mod.Logger:PrintInfo(string.format("Skipped loading framework %s", self:GetFrameworkVersion()))
    return
  end

  Script.Load("lua/" .. kModName .. "/Framework/ModuleLoader.lua")

  local LoadFrameworkModule = GetFrameworkModuleLoader()
  GetFrameworkModuleLoader = nil

  LoadFrameworkModule("Logging")

  Script.Load("lua/" .. kModName .. "/Config.lua")

  config = assert(GetModConfig, "Initialise: Config.lua malformed. Missing GetModConfig function.")(self.Logger:GetLogLevels())
  GetModConfig = nil

  assert(config, "Initialise: Config.lua malformed. GetModConfig doesn't return anything.")
  assert(type(config) == "table", "Initialise: Config.lua malformed. GetModConfig doesn't return expected type.")

  Script.Load("lua/" .. kModName .. "/Framework/ConfigValidation.lua")

  valid, reason = RunFrameworkValidator(config)
  assert(valid, "Initialise: Config failed validation. " .. reason)

  for i,v in ipairs(config.modules) do
    config.modules[i] = "Modules/" .. v
  end

  config.kModName = kModName
  self.config, config = config, nil

  for _,v in ipairs(frameworkModules) do
    LoadFrameworkModule(v)
  end

  assert(GetVersionInformation, "Config.lua malformed. GetVersionInformation does not exist")(Mod.Versioning)

  Mod.Libraries:LoadAllLibraries(self.config.libraries)

  _G[kModName] = self
  Shared.Message(string.format("[%s - %s] Framework %s loaded", kModName, current_vm, self:GetFrameworkVersion()))
end

function Mod:ValidateModule(name, value)
  if name and value and type(name) == "string" and type(value) == "table" then
    return true
  end

  return false, "Invalid module"
end

function Mod:GetFrameworkModules()
  return frameworkModules
end

function Mod:GetConfig()
  return self.config
end

function Mod:GetConfigLogLevel()
  return self.config.kLogLevel
end

function Mod:GetModName()
  return kModName
end

function Mod:GetModules()
  return self.config.modules
end

function Mod:GetFrameworkVersion()
  return framework_version
end

-- Returns the relative ns2 path used to find lua files
function Mod:FormatDir(module, name, file)
  local moduleType = module and type(module) or "nil"
  assert(moduleType == "string", "FormatDir: First argument expected to be of type string, was " .. moduleType)

  if name then
    if file then
      return string.format("lua/%s/%s/%s.lua", self:GetModName(), module, name)
    else
      return string.format("lua/%s/%s/%s/*.lua", self:GetModName(), module, name)
    end
  else
    return string.format("lua/%s/%s/*.lua", self:GetModName(), module)
  end
end

--[[
========================
      Helper Funcs
========================
]]

-- i wish the # operator was deterministic
function table.real_length(tbl)
  local count = 0
  for _,_ in pairs(tbl) do
    count = count + 1
  end
  return count
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

-- Init the stuff

Mod:Initialise()
