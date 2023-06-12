 --[[
    monitor Function Library
    Developed by Rudi Hansen, Start 2023-03-18
]]

local monitor = {}

local mon
local monSizeX, monSizeY
local activeScreen  = ""
local lastTouch     = ""

function monitor.init()
    mon = peripheral.wrap("right")
    monSizeX, monSizeY = mon.getSize()
    logFile.logWrite("monSizeX",monSizeX)
    logFile.logWrite("monSizeY",monSizeY)
end


function monitor.screenHandler()
    logFile.logWrite("In monitor.screenHandler()")
    monitor.drawMainScreen()
    activeScreen = "MAIN"

    while(true) do
        if(activeScreen=="MAIN" and lastTouch=="1")then
            lastTouch=""
            monitor.drawTurtleListScreen()
            activeScreen = "TURTLELIST"
        elseif(activeScreen=="MAIN" and lastTouch=="q")then
            lastTouch=""
            monitor.clear()
            error()
        elseif(activeScreen=="TURTLELIST" and lastTouch=="q")then
            lastTouch=""
            monitor.drawMainScreen()
            activeScreen = "MAIN"
        end
        monitor.yield()
    end
end

function monitor.touchHandler()
    logFile.logWrite("In monitor.touchHandler()")

    while(true) do
        event, side, x, y = os.pullEvent("monitor_touch")
        logFile.logWrite("event",event)
        logFile.logWrite("side",side)
        logFile.logWrite("x",x)
        logFile.logWrite("y",y)

        logFile.logWrite("activeScreen",activeScreen)
        if(activeScreen=="MAIN")then
            if(y==3)then
                logFile.logWrite("Pressed","1")
                lastTouch="1"
            elseif(y==4) then
                logFile.logWrite("Pressed","2")
                lastTouch="2"
            elseif(y==6) then
                logFile.logWrite("Pressed","q")
                lastTouch="q"
            end
        elseif(activeScreen=="TURTLELIST")then
            if(y==9)then
                logFile.logWrite("Pressed","q")
                lastTouch="q"
            end
        end
        monitor.yield()
    end
end

function monitor.yield()
    os.queueEvent("fake")
    os.pullEvent("fake")
end

function monitor.drawMainScreen()
    -- Clear Monitor setup
    mon.clear()
    mon.setTextScale(1) -- 1 Seems to be the standard, 0.5 makes the text smaller
    mon.setTextColor(colors.white)

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
    --logFile.logWrite("textPos",textPos)

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

function monitor.clear()
    mon.clear()
end

return monitor