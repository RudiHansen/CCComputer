 --[[
    screen Function Library
    Developed by Rudi Hansen, Start 2023-03-18
]]

local screen = {}

local monitor
local monitorSizeX, monitorSizeY

function screen.init()
    monitor = peripheral.wrap("right")
    monitorSizeX, monitorSizeY = monitor.getSize()
    logFile.logWrite("monitorSizeX",monitorSizeX)
    logFile.logWrite("monitorSizeY",monitorSizeY)
end

function screen.drawMainScreen()
    -- Clear Monitor setup
    monitor.clear()
    monitor.setTextScale(1) -- 1 Seems to be the standard, 0.5 makes the text smaller
    monitor.setTextColor(colors.white)

    screen.centerTextOnLine("********** MAIN **********",1)
    screen.writeAtPos("1 : Show Turtle List",10,3)
    screen.writeAtPos("2 : Show something new",10,4)
    screen.writeAtPos("q : Quit",10,6)
end

function screen.drawTurtleListScreen()
    -- Clear Monitor setup
    monitor.clear()
    monitor.setTextScale(1) -- 1 Seems to be the standard, 0.5 makes the text smaller
    monitor.setTextColor(colors.white)

    screen.centerTextOnLine("********** TURTLE LIST **********",1)
    screen.writeAtPos("Name",1,3)
    screen.writeAtPos("Status",9,3)
    screen.writeAtPos("Position",17,3)
    screen.writeAtPos("Inv",32,3)
    screen.writeAtPos("Fuel",36,3)

    screen.centerTextOnLine("BACK TO MAIN",9)
    screen.drawLineOnLine(10)
end

function screen.updateTurtleListOnScreen()
    local startLine = 4

    for i = 1,10,1 do
        local td = turtles.getTurtleData(i)
        if(td~=nil) then
            screen.writeTurtleDataOnLine(i,startLine)
            startLine = startLine + 1
        end
     end
end

function screen.writeTurtleDataOnLine(id,line)
    local td   = turtles.getTurtleData(id)
    local tPos = td.PosX .. " " .. td.PosZ .. " " .. td.PosY .. " " .. td.PosF

    screen.writeAtPos(td.Name,1,line)
    screen.writeAtPos(td.Status,9,line)
    screen.writeAtPos(tPos,17,line)
    screen.writeAtPos(td.Inv,32,line)
    screen.writeAtPos(td.Fuel,36,line)
end

function screen.centerTextOnLine(text,line)
    local textPos = ((monitorSizeX - string.len(text)) / 2) + 1
    logFile.logWrite("textPos",textPos)

    monitor.setCursorPos(textPos,line)
    monitor.write(text)
end

function screen.drawLineOnLine(line)
    monitor.setCursorPos(1,line)
    monitor.write(string.rep("-",monitorSizeX))
end

function screen.writeAtPos(text,x,y)
    monitor.setCursorPos(x,y)
    monitor.write(text)
end

return screen