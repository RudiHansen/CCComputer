--[[
    main program for Turtles
    Developed by Rudi Hansen on 2023-06-11
]]

-- Load all library's
modem     = require("lib.modem")
util      = require("lib.util")
logFile   = require("lib.logFile")
screen    = require("lib.screen")
event     = require("lib.event")
turtles   = require("lib.turtles")


-- Init library's
logFile.logFileOpen()
modem.init()
screen.init()

--screen.drawMainScreen()
screen.drawTurtleListScreen()

while(true)do
    ev,data,x,y = event.getAnyEvent()
    if(ev=="rednet_message") then
        turtles.messageToTurtleData(data,x)
        screen.updateTurtleListOnScreen()
    elseif(ev=="monitor_touch") then
        --screen.writeAtPos("Monitor touch",10,8)
        if(y==3)then
            screen.writeAtPos("Pressed 1          ",10,8)
        elseif(y==4) then
            screen.writeAtPos("Pressed 2          ",10,8)
        elseif(y==6) then
            screen.writeAtPos("Pressed q          ",10,8)
        end
    end
end

-- Finalize script
logFile.logFileClose()
