Script.Load("lua/Overview/LibDeflate.lua")

local LibDeflate = GetLibDeflate()

local function SendData(compressedJsonData)
    print("we're sending data for sure :)))")
end

local function SaveData(jsonData, compressedJsonData)
    local dataFile = io.open("config://RoundStats.json", "w+")
    local compressedDataFile = io.open("config://RoundStatsCompressed.txt", "w+")

    if dataFile then
        dataFile:write(jsonData)
        io.close(dataFile)
    end

    if compressedDataFile then
        compressedDataFile:write(compressedJsonData)
        io.close(compressedDataFile)
    end
end

function SaveAndSendRoundData(jsonStructure)
    local jsonData = json.encode(jsonStructure, { indent=true })
    local compressedJsonData = LibDeflate:CompressDeflate(json.encode(jsonStructure, { indent=false }))
    SaveData(jsonData, compressedJsonData)
    SendData(compressedJsonData)
end