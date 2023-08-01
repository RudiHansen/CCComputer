 --[[
    posList Function Library
    Developed by Rudi Hansen, Start 2023-06-22
]]

local posList = {}

local dataFileNamePosList = "posList.dat"

local posListData        = {Id=0,Name="",PosX=0,PosZ=0,PosY=0,Face=""}
local posListDataList    = {}

function posList.loadData()
    --logFile.logWrite("posList.loadData()")
    local fields = {}
    
    -- Check if file exists.
    local result = fs.exists(dataFileNamePosList)
    if(result==false)then
        return
    end

    -- Open file for reading
    local file = fs.open(dataFileNamePosList,   "r")

    for line in file.readLine do
        posListData         = {}
        posListData = posList.str2PosListData(line)

        table.insert(posListDataList,posListData)
        --logFile.logWrite("table.insert",posListData.Id)
        --logFile.logWrite("posListData.Name",posListData.Name)
    end

    -- Close file
    file:close()
end

function posList.saveData()
    -- Open file for write
    local outFile = fs.open(dataFileNamePosList,   "w")
    local outLine = ""

    -- Loop all records in posListDataList, and write to file
    for i=1,#posListDataList do
        posListData = {}
        posListData = posListDataList[i]
        --logFile.logWrite("posListData",posListData)
        outLine = posList.posListData2Str(posListData)
        --logFile.logWrite("outLine",outLine)
        outFile.writeLine(outLine)
    end
    outFile.flush()

    -- Close file
    outFile.close()
end

function posList.getPosListDataList()
    return posListDataList
end

function posList.editPosList(text)
    --logFile.logWrite("in posList.editPosList")
    --logFile.logWrite("text",text)

    local posListDataEdit = {}
    posListDataEdit = posList.str2PosListData(text)
    --logFile.logWrite("posListDataEdit",posListDataEdit)

    posListData   = {}
    --logFile.logWrite("posListDataEdit.Id",posListDataEdit.Id)
    --logFile.logWrite("posListDataList[tonumber(posListDataEdit.Id)]",posListDataList[tonumber(posListDataEdit.Id)])

    posListData         = posListDataList[tonumber(posListDataEdit.Id)]
    --logFile.logWrite("posListData",posListData)

    posListData.Name    = posListDataEdit.Name
    posListData.PosX    = posListDataEdit.PosX
    posListData.PosZ    = posListDataEdit.PosZ
    posListData.PosY    = posListDataEdit.PosY
    posListData.Face    = posListDataEdit.Face
    --logFile.logWrite("posListData",posListData)

    posList.saveData();
end

function posList.addPosList(text)
    --logFile.logWrite("in posList.editPosList")
    --logFile.logWrite("text",text)
    --logFile.logWrite("Before #posListDataList",#posListDataList)

    local posListDataAdd = {}
    posListDataAdd = posList.str2PosListData(text)
    --logFile.logWrite("posListDataAdd",posListDataAdd)

    table.insert(posListDataList,posListDataAdd)
    --logFile.logWrite("After #posListDataList",#posListDataList)

    posList.saveData();
end

function posList.deletePosList(id)
    --logFile.logWrite("in posList.deletePosList")
    --logFile.logWrite("id",id)
    --logFile.logWrite("Before #posListDataList",#posListDataList)

    table.remove(posListDataList,tonumber(id))
    --logFile.logWrite("After #posListDataList",#posListDataList)

    posList.saveData();
end

function posList.posListData2Str(posListData)
    return posListData.Id ..
           "," ..
           posListData.Name ..
           "," ..
           posListData.PosX ..
           "," ..
           posListData.PosZ ..
           "," ..
           posListData.PosY ..
           "," ..
           posListData.Face
end

function posList.str2PosListData(text)
    fields = {}
    for field in string.gmatch(text, "[^,]+") do
        table.insert(fields, field)
    end
    posListData         = {}
    posListData.Id      = fields[1]
    posListData.Name    = fields[2]
    posListData.PosX    = fields[3]
    posListData.PosZ    = fields[4]
    posListData.PosY    = fields[5]
    posListData.Face    = fields[6]

    return posListData
end

function posList.getPosListDataFromName(name)
    --logFile.logWrite("in posList.getPosListDataFromName")
    --logFile.logWrite("name",name)
    --logFile.logWrite("#posListDataList",#posListDataList)

    for i=1,#posListDataList do
        posListData = {}
        posListData = posListDataList[i]

        --logFile.logWrite("Testing posListData.Name",posListData.Name)
        if(posListData.Name == name)then
            outLine = posList.posListData2Str(posListData)
            --logFile.logWrite("outLine",outLine)
            return outLine
        end
    end
end

return posList