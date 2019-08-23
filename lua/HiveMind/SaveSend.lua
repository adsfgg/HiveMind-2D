Script.Load("lua/HiveMind/LibDeflate.lua")
Script.Load("lua/HiveMind/base64.lua")

--local HiveMindStatsURL = "localhost:8000/receive_round_data"
local HiveMindStatsURL = "https://hivemind.4sdf.co.uk/receive_round_data"

local LibDeflate = GetLibDeflate()
local B64 = GetBase64()

local function SendData(jsonData, SendChatMessage)
    local status = -128
    local reason = "No response."

    Shared.SendHTTPRequest( HiveMindStatsURL, "POST", { data = jsonData }, function(response)
        local data, pos, err = json.decode(response)

        if err then
            Shared.Message("Could not parse HiveMind response. Error: " .. ToString(err))
            status, reason  = 1, "Could not parse HiveMind response."
        else
            status = data['status']
            reason = data['reason']
        end

        if status ~= 0 then
            SendChatMessage("Demo failed to upload.")
            SendChatMessage("Status: " .. status)
            SendChatMessage("Reason: " .. reason)
        else
            -- notify the players that the demo was saved successfully.
            SendChatMessage("Demo recorded.")
            SendChatMessage("Round ID: " .. data['round_id'])
        end

    end)
end

local function SaveData(jsonData, cJsonData, bJsonData)
    local dataFile = io.open("config://RoundStats.json", "w+")
    local cDataFile = io.open("config://RoundStatsCompressed.bin", "w+")
    local bDataFile = io.open("config://RoundStatsB64.txt", "w+")

    if dataFile then
        dataFile:write(jsonData)
        io.close(dataFile)
    end

    if cDataFile then
        cDataFile:write(cJsonData)
        io.close(cDataFile)
    end

    if bDataFile then
        bDataFile:write(bJsonData)
        io.close(bDataFile)
    end
end

function SaveAndSendRoundData(jsonStructure, SendChatMessage)
    local jsonData = json.encode(jsonStructure, { indent=true })
    local cJsonData = LibDeflate:CompressZlib(json.encode(jsonStructure, { index = false }))
    local bJsonData = B64.encode(cJsonData)

    SaveData(jsonData, cJsonData, bJsonData)
    SendData(bJsonData, SendChatMessage)
end