Script.Load("lua/Overview/LibDeflate.lua")

local LibDeflate = GetLibDeflate()
local ns2OverviewStatsURL = "https://overview.4sdf.co.uk/recieveRoundStats"

local function SendData(compressedJsonData)
    if not Server.IsDedicated() then
        print("Overview: Not sending data for local rounds.")
        return
    end

    Shared.SendHTTPRequest( ns2OverviewStatsURL, "POST", { data = compressedJsonData }, function(response)
        local data, pos, err = json.decode(response)

        if err then
            Shared.Message("Could not parse NS2 overview response. Error: " .. ToString(err) .. ". Response: " .. response)
        end
    end)
end

local function SaveData(jsonData, compressedJsonData)
    local dataFile = io.open("config://RoundStats.json", "w+")
    local cfile = io.open("config://RoundStatsCompressed.txt", "w+")

    if dataFile then
        dataFile:write(jsonData)
        io.close(dataFile)
    end

    if cfile then
        cfile:write(compressedJsonData)
        io.close(cfile)
    end
end

function SaveAndSendRoundData(jsonStructure)
    local jsonData = json.encode(jsonStructure, { indent=true })
    local now = Shared.GetTime()
    local compressedJsonData = LibDeflate:CompressDeflate(json.encode(jsonStructure, { indent=false }))
    local timeTaken = Shared.GetTime() - now

    print("Compression took: " .. timeTaken .. "ms")

    now = Shared.GetTime()
    SaveData(jsonData, compressedJsonData)
    timeTaken = Shared.GetTime() - now
    print("saving regular file took: " .. timeTaken)
    now = Shared.GetTime()
    SendData(compressedJsonData)
    timeTaken = Shared.GetTime() - now
    print("saving compressed file took: " .. timeTaken)
end