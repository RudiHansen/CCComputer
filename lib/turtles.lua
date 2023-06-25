 --[[
    turtles Function Library
    Developed by Rudi Hansen, Start 2023-03-18
]]

local turtles = {}

local turtlesTable = {}
local dataFileNameTurtles = "turtles.dat"

function turtles.loadData()
    --logFile.logWrite("turtles.loadData()")
    local fields = {}
    
    -- Open file for reading
    local file = fs.open(dataFileNameTurtles,   "r")

    for line in file.readLine do
        turtlesData         = {}
        turtlesData = turtles.str2TurtlesData(line)

        --logFile.logWrite("table.insert",turtlesData.Id)
        --logFile.logWrite("table.insert",turtlesData.Name)
        turtlesTable[tonumber(turtlesData.Id)] = turtlesData        
    end
    --logFile.logWrite("turtlesTable",turtlesTable)

    -- Close file
    file:close()
end

function turtles.saveData()
    --logFile.logWrite("In turtles.saveData()")    
    -- Open file for write
    local outFile = fs.open(dataFileNameTurtles,   "w")
    local outLine = ""

    -- Loop all records in posListDataList, and write to file
    --logFile.logWrite("#turtlesTable",#turtlesTable)    
    for i=1,10 do
        turtlesData = {}
        turtlesData = turtlesTable[i]
        --logFile.logWrite("turtlesData",turtlesData)
        if(turtlesData ~= nil)then
            outLine = turtles.turtlesData2Str(turtlesData)
            --logFile.logWrite("outLine",outLine)
            outFile.writeLine(outLine)
        end
    end
    outFile.flush()

    -- Close file
    outFile.close()
end

function turtles.turtlesData2Str(turtlesData)
    return turtlesData.Id ..
           "," ..
           turtlesData.Name ..
           "," ..
           turtlesData.Status ..
           "," ..
           turtlesData.PosX ..
           "," ..
           turtlesData.PosZ ..
           "," ..
           turtlesData.PosY ..
           "," ..
           turtlesData.PosF ..
           "," ..
           turtlesData.Inv ..
           "," ..
           turtlesData.Fuel
end

function turtles.str2TurtlesData(text)
    fields = {}
    for field in string.gmatch(text, "[^,]+") do
        table.insert(fields, field)
    end
    posListData         = {}
    posListData.Id      = fields[1]
    posListData.Name    = fields[2]
    posListData.Status  = fields[3]
    posListData.PosX    = fields[4]
    posListData.PosZ    = fields[5]
    posListData.PosY    = fields[6]
    posListData.PosF    = fields[7]
    posListData.Inv     = fields[8]
    posListData.Fuel    = fields[9]

    return posListData
end

function turtles.addFromStatusMessage(message)
    local turtleData = {}

    if(event=="modem_message" or event=="timer" ) then
        return
    end

    --logFile.logWrite("screen.getAnyEvent()")
    --logFile.logWrite("event",event)
    --logFile.logWrite("data",data)
    --logFile.logWrite("x",x)
    --logFile.logWrite("y",y)

    return event,data,x,y
end

function turtles.messageToTurtleData(id,message)
    local messageSplit = {}

    for element in string.gmatch(message, "[^;]+") do
        table.insert(messageSplit,element)    
    end

    local turtleData = {
                    Id      = id,
                    Name    = messageSplit[2],
                    Status  = messageSplit[9],
                    PosX    = messageSplit[3],
                    PosZ    = messageSplit[4],
                    PosY    = messageSplit[5],
                    PosF    = messageSplit[6],
                    Inv     = messageSplit[7],
                    Fuel    = messageSplit[8]
                }
    
    --logFile.logWrite("turtles.messageToTurtleData ",id)
    --logFile.logWrite("turtleData",turtleData)
    turtlesTable[id] = turtleData
end

function turtles.getTurtleData(id)
    --logFile.logWrite("In turtles.getTurtleData",id)
    --logFile.logWrite("turtlesTable",turtlesTable)
    td = turtlesTable[id]
    --logFile.logWrite("td",td)

    return td
end

function turtles.getTurtleName(id)
    --logFile.logWrite("turtles.getTurtleName Id=",id)
    --logFile.logWrite(turtlesTable)    
    local td = turtlesTable[id]
    --logFile.logWrite(td)    
    if(td~=nil)then
        return td.Name
    end
end

return turtles