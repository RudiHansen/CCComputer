--[[
    testReadTD program for Turtles
    Developed by Rudi Hansen on 2023-06-11
]]

-- Load all library's
turtleJobs     = require("lib.turtleJobs")

turtleJobs.loadData()

local td = turtleJobs.GetJobForTurtle("Miner2")
print(td.TurtleName.." - "..td.Status.." - "..td.JobType)

td = turtleJobs.GetJobForTurtle("Miner2")
print(td.TurtleName.." - "..td.Status.." - "..td.JobType)

td = turtleJobs.GetJobForTurtle("Miner2")
print(td.TurtleName.." - "..td.Status.." - "..td.JobType)

td = turtleJobs.GetJobForTurtle("Miner2")
print(td.TurtleName.." - "..td.Status.." - "..td.JobType)

td = turtleJobs.GetJobForTurtle("Miner2")
print(td.TurtleName.." - "..td.Status.." - "..td.JobType)

td = turtleJobs.GetJobForTurtle("Miner2")
print(td.TurtleName.." - "..td.Status.." - "..td.JobType)
