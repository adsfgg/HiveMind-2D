--[[
    Generic Tracker class.
]]

-- Abstract
class 'Tracker'

Tracker.lastUpdate = {}
Tracker.nextUpdate = {}

-- Here we gather info for the tracker
function Tracker:OnUpdate()
    self.lastUpdate = self.nextUpdate
    self.nextUpdate = {}

    return self.lastUpdate
end

function Tracker:OnReset()
    self.lastUpdate = {}
    self.nextUpdate = {}
end

function Tracker:GetName()
    assert(false)
end

function Tracker:ShouldUpdate(key, value, subarray)
    assert(key)
    assert(value)

    if subarray then
        if not self.lastUpdate[subarray] then
            print("updating because we're using a subarray that didnt exist last frame")
            return true
        end

        if self.lastUpdate[subarray][key] == value then
            print("not updating because the value was the same as last frame. [" .. subarray .. "][" .. key .. "] == " .. value)
            return false
        end
    else
        if self.lastUpdate[key] == value then
            print("not updating because the value was the same as last frame. [" .. key .. "] == " .. value)
            return false
        end
    end

    return true
end

function Tracker:TryUpdateValue(key, value, subarray)
    if self:ShouldUpdate(key, value, subarray) then
        self:UpdateValue(key, value, subarray)
    end
end

function Tracker:UpdateValue(key, value, subarray)
    assert(key)
    assert(value)

    if subarray then
        if not self.nextUpdate[subarray] then
            self.nextUpdate[subarray] = {}
        end

        self.nextUpdate[subarray][key] = value
    else
        self.nextUpdate[key] = value
    end
end

function Tracker:DeleteValue(key)
    self.nextUpdate[key] = nil
end

function Tracker:AddValue(key, value)
    assert(key)
    assert(value)

    assert(not self.nextUpdate[key])
    self:UpdateValue(key, value)
end

function Tracker:GetLastUpdate()
    return self.lastUpdate
end

function Tracker:GetNextUpdate()
    return self.nextUpdate
end
