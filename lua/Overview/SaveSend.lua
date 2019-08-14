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

local function SaveData(jsonData)
    local dataFile = io.open("config://RoundStats.json", "w+")

    if dataFile then
        dataFile:write(jsonData)
        io.close(dataFile)
    end
end

function SaveAndSendRoundData(jsonStructure)
    local jsonData = json.encode(jsonStructure, { indent=true })
    local compressedJsonData = LibDeflate:CompressDeflate(json.encode(jsonStructure, { indent=false }))
    SaveData(jsonData, compressedJsonData)
    SendData(compressedJsonData)
end