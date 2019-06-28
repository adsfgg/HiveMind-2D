local Mod = GetMod()
local Bindings = {}

local bindingAdditions = {}

function Bindings:GetBindingAdditions()
    return bindingAdditions
end

function Bindings:AddNewBind(name, type, transKey, default, afterName)
    assert(name)
    assert(type)
    assert(transKey)
    assert(default)
    assert(afterName)
    table.insert(bindingAdditions, { name, type, transKey, default, afterName })
end

function GetFrameworkModuleChanges()
    return "Bindings", Bindings
end

local function UpdateBindingData()
    local globalControlBindings = debug.getupvaluex(BindingsUI_GetBindingsData, "globalControlBindings")
    local defaults = debug.getupvaluex(GetDefaultInputValue, "defaults")
    local bindingChanges = Bindings:GetBindingAdditions()

    for _,v in ipairs(bindingChanges) do
        local afterName = v[5]

        Mod.Logger:PrintDebug("Adding new bind \"" .. v[1].. "\" after " .. afterName)

        v[3] = Locale.ResolveString(v[3])

        local index

        -- globalControlBindingss

        for i, bind in ipairs(globalControlBindings) do
            if bind == afterName then
                index = i + 4
            end
        end

        assert(index, "BindingChanges: Binding \"" .. afterName .. "\" does not exist.")

        for i=0,3 do
            table.insert(globalControlBindings, index + i, v[i + 1])
        end

        -- defaults

        for i,def in pairs(defaults) do
            if def[1] == afterName then
                table.insert(defaults, i+1, {v[1], v[4]})
                break
            end
        end
    end
end

Event.Hook("LoadComplete", UpdateBindingData)