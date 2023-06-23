--[[
    main program for Turtles
    Developed by Rudi Hansen on 2023-06-11
]]

-- Load all library's
modem      = require("lib.modem")
util       = require("lib.util")
logFile    = require("lib.logFile")
monitor    = require("lib.monitor")
screen     = require("lib.screen")
event      = require("lib.event")
turtles    = require("lib.turtles")
turtleJobs = require("lib.turtleJobs")
posList    = require("lib.posList")


-- Init library's
logFile.logFileOpen()
modem.init()
monitor.init()
screen.init()
monitor.clear()
screen.clear()
turtleJobs.loadData()
posList.loadData()


--monitor.drawMainScreen()
--monitor.drawTurtleListScreen()


--while(true) do
    parallel.waitForAny(monitor.screenHandler,
                        monitor.touchHandler,
                        screen.screenHandler,
                        modem.receiveMessages)
--end

-- Finalize script
monitor.clear()
logFile.logFileClose()
