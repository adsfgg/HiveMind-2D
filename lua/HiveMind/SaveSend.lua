Script.Load("lua/HiveMind/LibDeflate.lua")
Script.Load("lua/HiveMind/base64.lua")

local HiveMindStatsURL = "https://hivemind.4sdf.co.uk/receive_round_data"
local HiveMindStatsURLDebug = "127.0.1.1:8000/receive_round_data"

local LibDeflate = GetLibDeflate()
local B64 = GetBase64()
local HiveMindFilePath = "config://hivemind/RoundData.%s"

local function HTTPRequestCallback(response, request_error)
    local status, reason, data, pos, err

    if request_error then
        status, reason = 128, request_error
    else
        data, pos, err = json.decode(response)

        if err then
            Shared.Message("Could not parse HiveMind response. Error: " .. ToString(err))
            status, reason  = 1, "Could not parse HiveMind response."
        else
            status = data['status']
            reason = data['reason']
        end
    end

    if status ~= 0 then
        SendHiveMindChatMessage("Demo failed to upload.")
        SendHiveMindChatMessage("Status: " .. status)
        SendHiveMindChatMessage("Reason: " .. reason)
    else
        -- notify the players that the demo was saved successfully.
        SendHiveMindChatMessage("Demo recorded.")
        SendHiveMindChatMessage("Round ID: " .. data['round_id'])
    end
end

local function SendData(jsonData, debug)
    local url = debug and HiveMindStatsURLDebug or HiveMindStatsURL
    Shared.SendHTTPRequest(url, "POST", { data = jsonData }, HTTPRequestCallback)
end

local function CreateFilePath(ext)
    return string.format(HiveMindFilePath, ext)
end

local function SaveData(bJsonData)
    local demoFile = assert(io.open(CreateFilePath(uuid, "demo"), "w+"))
    dataFile:write(base64stream)
    io.close(dataFile)
end

local function SaveDataDebug(jsonData, cJsonData, bJsonData)
    local dataFile = assert(io.open(CreateFilePath("json"), "w+"))
    local cDataFile = assert(io.open(CreateFilePath("bin"), "w+"))
    local bDataFile = assert(io.open(CreateFilePath("b64"), "w+"))

    dataFile:write(jsonData)
    cDataFile:write(cJsonData)
    bDataFile:write(bJsonData)

    io.close(dataFile)
    io.close(cDataFile)
    io.close(bDataFile)
end

function SaveAndSendRoundData(jsonStructure, debug)
    -- First we encode our table as JSON
    local jsonData = json.encode(jsonStructure, { indent=true })
    -- Then we compress using Deflate
    local cJsonData = LibDeflate:CompressZlib(json.encode(jsonStructure, { index = false }))
    -- Then we encode using B64, this will increase the file size slightly but will make it transmittable via post headers
    local bJsonData = B64.encode(cJsonData)

    if debug then
        SaveDataDebug(jsonData, cJsonData, bJsonData)
    else
        SaveData(bJsonData)
    end

    SendData(bJsonData, debug)
end