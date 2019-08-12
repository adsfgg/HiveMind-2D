--[[
    Here we track general things each tick

    Currently tracks:
    * Gametime (in seconds)
]]

Script.Load("lua/Overview/Trackers/Tracker.lua")

class 'GeneralTracker' (Tracker)

local function GetGametime()
    return math.max( 0, math.floor(Shared.GetTime()) - GetGameInfoEntity():GetStartTime() )
end

function GeneralTracker:OnUpdate()
    local gameTime = GetGametime()

    if self:ShouldUpdate("gameTime", gameTime) then
        self:UpdateValue("gameTime", gameTime)
    end

    Tracker.OnUpdate(self)
end