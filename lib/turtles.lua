 --[[
    turtles Function Library
    Developed by Rudi Hansen, Start 2023-03-18
]]

local turtles = {}

local turtlesTable = {}

function turtles.addFromStatusMessage(message)
    local turtleData = {}

    if(event=="modem_message" or event=="timer" ) then
        return
    end

    logFile.logWrite("screen.getAnyEvent()")
    logFile.logWrite("event",event)
    logFile.logWrite("data",data)
    logFile.logWrite("x",x)
    logFile.logWrite("y",y)

    return event,data,x,y
end

function turtles.messageToTurtleData(id,message)
    local messageSplit = {}

    for element in string.gmatch(message, "[^;]+") do
        table.insert(messageSplit,element)    
    end

    local turtleData = {
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
    return turtlesTable[id]
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