Script.Load("lua/Overview/LibDeflate.lua")

local LibDeflate = GetLibDeflate()
local ns2OverviewStatsURL = "https://overview.4sdf.co.uk/receiveRoundData"

local function SendData(jsonData, SendChatMessage)
    local status = -128
    local reason = "No response."

    Shared.SendHTTPRequest( ns2OverviewStatsURL, "POST", { data = jsonData }, function(response)
        local data, pos, err = json.decode(response)

        if err then
            Shared.Message("Could not parse NS2 overview response. Error: " .. ToString(err) .. ". Response: " .. response)
            status, reason  = -1, "Could not parse NS2 Overview response."
        else
            status = data['status']
            reason = data['reason']

            if status ~= 0 then
                Shared.Message("Overview: Status - " .. status)
                Shared.Message("Overview: Reason - " .. reason)
            end
        end

        if status ~= 0 then
            SendChatMessage("Demo failed to upload.")
            SendChatMessage("Status: " .. status)
            SendChatMessage("Reason: " .. reason)
        else
            -- notify the players that the demo was saved successfully.
            SendChatMessage("Demo recorded.")
            SendChatMessage("Round ID: " .. data['round-id'])
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

function SaveAndSendRoundData(jsonStructure, SendChatMessage)
    local jsonData = json.encode(jsonStructure, { indent=true })
    SaveData(jsonData)
    SendData(jsonData, SendChatMessage)
end