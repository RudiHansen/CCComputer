 --[[
    turtleJobs Function Library
    Developed by Rudi Hansen, Start 2023-06-13
]]

local turtleJobs = {}

local dataFileNameTurtleJobs = "turtleJobs.dat"

local turtleJobsData        = {TurtleName="",Status="",JobType="",x1=0,z1=0,y1=0,f1="",x2=0,z2=0,y2=0,f2="",axisPriority=""}
local turtleJobsDataList    = {}

function turtleJobs.loadData()
    --logFile.logWrite("turtleJobs.loadData()")
    local fields = {}
    
    -- Open file for reading
    local file = fs.open(dataFileNameTurtleJobs,   "r")

    for line in file.readLine do
        fields = {}
        for field in string.gmatch(line, "[^,]+") do
            table.insert(fields, field)
        end
        turtleJobsData              = {}
        turtleJobsData.TurtleName   = fields[1]
        turtleJobsData.Status       = fields[2]
        turtleJobsData.JobType      = fields[3]
        turtleJobsData.x1           = fields[4]
        turtleJobsData.z1           = fields[5]
        turtleJobsData.y1           = fields[6]
        turtleJobsData.f1           = fields[7]
        turtleJobsData.x2           = fields[8]
        turtleJobsData.z2           = fields[9]
        turtleJobsData.y2           = fields[10]
        turtleJobsData.f2           = fields[11]
        turtleJobsData.axisPriority = fields[12]
        table.insert(turtleJobsDataList,turtleJobsData)
        logFile.logWrite("table.insert",turtleJobsData.TurtleName)
        logFile.logWrite("turtleJobsData.axisPriority",turtleJobsData.axisPriority)
    end

    -- Close file
    file:close()
end

function turtleJobs.GetJobForTurtle(turtleName)
    --logFile.logWrite("turtleJobs.GetJobForTurtle ",turtleName)
    for i=1,#turtleJobsDataList do
        turtleJobsData = turtleJobsDataList[i]
        --logFile.logWrite("turtleJobsData.TurtleName",turtleJobsData.TurtleName)
        --logFile.logWrite("turtleJobsData.Status",turtleJobsData.Status)
        if(turtleJobsData.TurtleName == turtleName and turtleJobsData.Status=="NEW")then
            table.remove(turtleJobsDataList,i)
            --logFile.logWrite("Return data")
            return turtleJobsData
        end
    end
    --logFile.logWrite("Return nil")
    return nil
end

function turtleJobs.Job2MsgStr(turtleJobData)
    if(turtleJobData == nil)then
        return ""
    end
    return         turtleJobData.TurtleName   ..","..
                   turtleJobData.Status       ..","..
                   turtleJobData.JobType      ..","..
                   turtleJobData.x1           ..","..
                   turtleJobData.z1           ..","..
                   turtleJobData.y1           ..","..
                   turtleJobData.f1           ..","..
                   turtleJobData.x2           ..","..
                   turtleJobData.z2           ..","..
                   turtleJobData.y2           ..","..
                   turtleJobData.f2           ..","..
                   turtleJobData.axisPriority
end

return turtleJobs