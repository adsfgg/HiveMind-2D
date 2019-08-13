--[[
    Here we track general things each tick

    Currently tracks:
    * Gametime (in seconds)
]]

Script.Load("lua/Overview/Trackers/Tracker.lua")

class 'GeneralTracker' (Tracker)

function GeneralTracker:GetName()
    return "general"
end

function GeneralTracker:OnUpdate()
    local gameTime = Overview:GetGametime()

    self:TryUpdateValue("gameTime", gameTime)

    return Tracker.OnUpdate(self)
end