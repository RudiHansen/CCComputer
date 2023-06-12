--[[
    main program for Turtles
    Developed by Rudi Hansen on 2023-06-11
]]

-- Load all library's
modem     = require("lib.modem")
util      = require("lib.util")
logFile   = require("lib.logFile")
monitor    = require("lib.monitor")
event     = require("lib.event")
turtles   = require("lib.turtles")


-- Init library's
logFile.logFileOpen()
modem.init()
monitor.init()

--monitor.drawMainScreen()
monitor.drawTurtleListScreen()


while(true) do
    parallel.waitForAll(modem.receiveMessages())
end

while(true)do
    ev,data,x,y = event.getAnyEvent()
    if(ev=="rednet_message") then
        turtles.messageToTurtleData(data,x)
        monitor.updateTurtleListOnScreen()
    elseif(ev=="monitor_touch") then
        --monitor.writeAtPos("Monitor touch",10,8)
        if(y==3)then
            monitor.writeAtPos("Pressed 1          ",10,8)
        elseif(y==4) then
            monitor.writeAtPos("Pressed 2          ",10,8)
        elseif(y==6) then
            monitor.writeAtPos("Pressed q          ",10,8)
        end
    end
end

-- Finalize script
logFile.logFileClose()
