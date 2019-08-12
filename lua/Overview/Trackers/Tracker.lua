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
end

function Tracker:ShouldUpdate(key, value)
    assert(key)
    assert(value)
    assert(self.lastUpdate[key])

    if self.lastUpdate[key] == value then
        return false
    end

    return true
end

function Tracker:UpdateValue(key, value)
    assert(key)
    assert(value)

    self.nextUpdate[key] = value
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
