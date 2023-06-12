 --[[
    monitor Function Library
    Developed by Rudi Hansen, Start 2023-03-18
]]

local monitor = {}

local mon
local monSizeX, monSizeY

function monitor.init()
    mon = peripheral.wrap("right")
    monSizeX, monSizeY = mon.getSize()
    logFile.logWrite("monSizeX",monSizeX)
    logFile.logWrite("monSizeY",monSizeY)
end

function monitor.drawMainScreen()
    -- Clear Monitor setup
    monr.clear()
    monr.setTextScale(1) -- 1 Seems to be the standard, 0.5 makes the text smaller
    monr.setTextColor(colors.white)

    monitor.centerTextOnLine("********** MAIN **********",1)
    monitor.writeAtPos("1 : Show Turtle List",10,3)
    monitor.writeAtPos("2 : Show something new",10,4)
    monitor.writeAtPos("q : Quit",10,6)
end

function monitor.drawTurtleListScreen()
    -- Clear Monitor setup
    mon.clear()
    mon.setTextScale(1) -- 1 Seems to be the standard, 0.5 makes the text smaller
    mon.setTextColor(colors.white)

    monitor.centerTextOnLine("********** TURTLE LIST **********",1)
    monitor.writeAtPos("Name",1,3)
    monitor.writeAtPos("Status",9,3)
    monitor.writeAtPos("Position",17,3)
    monitor.writeAtPos("Inv",32,3)
    monitor.writeAtPos("Fuel",36,3)

    monitor.centerTextOnLine("BACK TO MAIN",9)
    monitor.drawLineOnLine(10)
end

function monitor.updateTurtleListOnScreen()
    local startLine = 4

    for i = 1,10,1 do
        local td = turtles.getTurtleData(i)
        if(td~=nil) then
            monitor.writeTurtleDataOnLine(i,startLine)
            startLine = startLine + 1
        end
     end
end

function monitor.writeTurtleDataOnLine(id,line)
    local td   = turtles.getTurtleData(id)
    local tPos = td.PosX .. " " .. td.PosZ .. " " .. td.PosY .. " " .. td.PosF

    monitor.writeAtPos(td.Name,1,line)
    monitor.writeAtPos(td.Status,9,line)
    monitor.writeAtPos(tPos,17,line)
    monitor.writeAtPos(td.Inv,32,line)
    monitor.writeAtPos(td.Fuel,36,line)
end

function monitor.centerTextOnLine(text,line)
    local textPos = ((monSizeX - string.len(text)) / 2) + 1
    logFile.logWrite("textPos",textPos)

    mon.setCursorPos(textPos,line)
    mon.write(text)
end

function monitor.drawLineOnLine(line)
    mon.setCursorPos(1,line)
    mon.write(string.rep("-",monSizeX))
end

function monitor.writeAtPos(text,x,y)
    mon.setCursorPos(x,y)
    mon.write(text)
end

return monitor