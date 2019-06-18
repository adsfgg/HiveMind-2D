function Embryo:GetTeam()
    -- all embryo's are aliens. getteamnumber returns -1 for some reason and getteam
    -- doesn't exist despite being called in Embyro.lua
    -- /shrug
    return GetGamerules():GetTeam2()
end