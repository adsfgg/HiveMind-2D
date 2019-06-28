local Mod = GetMod()
local Logger = {}

local kLogLevels = {
    fatal = {display="Fatal", level=0},
    error = {display="Error", level=1},
    warn  = {display="Warn",  level=2},
    info  = {display="Info",  level=3},
    debug = {display="Debug", level=4},
}

function Logger:GetLogLevels()
    return kLogLevels
end

function Logger:PrintCallStack()
    Shared.Message(Script.CallStack())
end

-- Shared.Message wrapper
function Logger:Print(str, level, vm)
    local strType = str and type(str) or "nil"
    assert(strType == "string", "Print: First argument expected to be of type string, was " .. strType)

    local logLevel = Mod:GetConfigLogLevel()
    local kModName = Mod:GetModName()

    level = level or kLogLevels.info

    local levelType = level and type(level) or "nil"
    assert(levelType == "table", "Print: Second argument expected to be of type table, was " .. levelType)

    if logLevel.level < level.level then
        return
    end

    local current_vm = Client and "Client" or Server and "Server" or Predict and "Predict" or "Unknown"

    local msg = string.format("[%s - %s] (%s) %s", kModName, current_vm, level.display, str)

    if not vm
            or vm == "Server" and Server
            or vm == "Client" and Client
            or vm == "Predict" and Predict
            or vm == "all" then

        Shared.Message(msg)
    end
end

-- Debug print
function Logger:PrintDebug(str, vm)
    local strType = str and type(str) or "nil"
    assert(strType == "string", "DebugPrint: First argument expected to be of type string, was " .. strType)
    self:Print(str, kLogLevels.debug, vm)
end

-- Info print
function Logger:PrintInfo(str, vm)
    local strType = str and type(str) or "nil"
    assert(strType == "string", "PrintInfo: First argument expected to be of type string, was " .. strType)
    self:Print(str, kLogLevels.info, vm)
end

-- Warning print
function Logger:PrintWarn(str, vm)
    local strType = str and type(str) or "nil"
    assert(strType == "string", "PrintWarn: First argument expected to be of type string, was " .. strType)
    self:Print(str, kLogLevels.warn, vm)
end

-- Error print
function Logger:PrintError(str, vm)
    local strType = str and type(str) or "nil"
    assert(strType == "string", "PrintError: First argument expected to be of type string, was " .. strType)
    self:Print(str, kLogLevels.error, vm)
end

-- Fatal print
function Logger:PrintFatal(str, vm)
    local strType = str and type(str) or "nil"
    assert(strType == "string", "PrintFatal: First argument expected to be of type string, was " .. strType)
    self:Print(str, kLogLevels.fatal, vm)
end

-- Prints the mod version to console using the given vm
function Logger:PrintVersion(vm)
    local version = Mod.Versioning:GetVersion()
    self:PrintInfo(string.format("%s version: %s loaded", Mod:GetModName(), version), vm)
end

function Logger:SendChatMessage(msg)
    local modName = Mod:GetModName()

    Server.SendNetworkMessage("Chat", BuildChatMessage(false, modName, -1, kTeamReadyRoom, kNeutralTeamType, msg), true)
    Shared.Message("Chat All - " .. modName .. ": " .. msg)
    Server.AddChatToHistory(msg, modName, 0, kTeamReadyRoom, false)
end

function GetFrameworkModuleChanges()
    return "Logger", Logger
end