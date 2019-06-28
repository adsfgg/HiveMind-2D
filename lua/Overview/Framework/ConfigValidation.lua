local Mod = GetMod()
local configOptions = {
    {
        var             = "kLogLevel",
        expectedType    = "table",
        required        = false,
        default         = Mod.Logger:GetLogLevels().info,
        displayDefault  = "info",
        warn            = true,
        validator       =
        function(tbl)
            assert(tbl)
            for _,v in pairs(Mod.Logger:GetLogLevels()) do
                if v == tbl then
                    return true
                end
            end
            return false
        end
    },

    {
        var             = "kShowInFeedbackText",
        expectedType    = "boolean",
        required        = false,
        default         = false,
        displayDefault  = "false",
        warn            = true
    },

    {
        var             = "kModVersion",
        expectedType    = "string",
        required        = false,
        default         = "0",
        displayDefault  = "0",
        warn            = true
    },

    {
        var             = "kModBuild",
        expectedType    = "string",
        required        = false,
        default         = "1",
        displayDefault  = "1",
        warn            = true
    },

    {
        var             = "disableRanking",
        expectedType    = "boolean",
        required        = false,
        default         = false,
        displayDefault  = "false",
        warn            = true
    },

    {
        var             = "modules",
        expectedType    = "table",
        required        = true,
        default         = {},
        displayDefault  = "new table",
        warn            = true,
        validator       =
        function(tbl)
            assert(tbl)
            for _,v in ipairs(tbl) do
                if type(v) ~= "string" then
                    return false
                end
            end
            return true
        end,
    },

    {
        var             = "use_config",
        expectedType    = "string",
        required        = false,
        default         = "none",
        displayDefault  = "none",
        warn            = true,
        validator       =
        function(str)
            assert(str)
            local v = str:lower()
            local validOptions = {
                "none",
                "client",
                "server",
                "both"
            }

            return table.contains(validOptions, v)
        end,
    },

    {
        var             = "techIdsToAdd",
        expectedType    = "table",
        required        = false,
        default         = {},
        displayDefault  = "new table",
        warn            = false,
        validator       =
        function(tbl)
            assert(tbl)
            for _,v in ipairs(tbl) do
                if type(v) ~= "string" then
                    return false
                end
            end
            return true
        end
    },

    {
        var             = "libraries",
        expectedType    = "table",
        required        = false,
        default         = {},
        displayDefault  = "new table",
        warn            = false,
        validator       =
        function(tbl)
            assert(tbl)
            for _,v in ipairs(tbl) do
                if type(v) ~= "string" then
                    return false
                end
            end
            return true
        end
    }
}

local function ValidateConfigOption(configVar, configOption)
    if type(configVar) ~= configOption.expectedType then
        return false, string.format("Expected type \"%s\" for variable \"%s\", got \"%s\" instead", configOption.expectedType, configOption.var, type(configVar))
    end

    if configOption.validator then
        local valid = configOption.validator(configVar)
        if not valid then
            return false, string.format("Validator failed for variable \"%s\"", configOption.var)
        end
    end

    return true, "pass"
end

local function LoadDefaults(config, v)
    option = v.default
    config[v.var] = option

    if v.warn then
        Shared.Message(string.format("Using default value for option \"%s\" (%s)", v.var, v.displayDefault))
    end
end

local function ValidateConfig(config)
    local configLength = table.real_length(config)
    local configOptionsLength = #configOptions

    -- is this really needed?
    if configLength > configOptionsLength then
        return false, "Too many config options set"
    end

    for _,v in ipairs(configOptions) do
        if config[v.var] ~= nil then
            local valid, reason = ValidateConfigOption(config[v.var], v)

            if not valid then
                return false, reason
            end
        else
            if v.required then
                return false, "Missing required config option \"" .. v.var .. "\""
            end

            LoadDefaults(config, v)
        end
    end

    return true, "passed"
end

function RunFrameworkValidator(config)
    return ValidateConfig(config)
end