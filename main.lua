--[[
    main program for Turtles
    Developed by Rudi Hansen on 2023-06-11
]]

-- Load all library's
modem     = require("lib.modem")
util      = require("lib.util")
logFile   = require("lib.logFile")
monitor   = require("lib.monitor")
event     = require("lib.event")
turtles   = require("lib.turtles")


-- Init library's
logFile.logFileOpen()
modem.init()
monitor.init()
monitor.clear()


--monitor.drawMainScreen()
--monitor.drawTurtleListScreen()


while(true) do
    parallel.waitForAny(monitor.screenHandler,monitor.touchHandler)
end

-- Finalize script
monitor.clear()
logFile.logFileClose()
