 --[[
    turtleJobs Function Library
    Developed by Rudi Hansen, Start 2023-06-13
]]

local turtleJobs = {}

local dataFileNameTurtleJobs = "turtleJobs.dat"

local turtleJobsData        = {Id=0,TurtleName="",Status="",JobType="",x1=0,z1=0,y1=0,f1="",x2=0,z2=0,y2=0,f2="",axisPriority=""}
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
        turtleJobsData.Id           = fields[1]
        turtleJobsData.TurtleName   = fields[2]
        turtleJobsData.Status       = fields[3]
        turtleJobsData.JobType      = fields[4]
        turtleJobsData.x1           = fields[5]
        turtleJobsData.z1           = fields[6]
        turtleJobsData.y1           = fields[7]
        turtleJobsData.f1           = fields[8]
        turtleJobsData.x2           = fields[9]
        turtleJobsData.z2           = fields[10]
        turtleJobsData.y2           = fields[11]
        turtleJobsData.f2           = fields[12]
        turtleJobsData.axisPriority = fields[13]
        table.insert(turtleJobsDataList,turtleJobsData)
        --logFile.logWrite("table.insert",turtleJobsData.TurtleName)
        --logFile.logWrite("turtleJobsData.axisPriority",turtleJobsData.axisPriority)
    end

    -- Close file
    file:close()
end

function turtleJobs.saveData()
    --logFile.logWrite("turtleJobs.saveData")
    -- Open file for write
    local outFile = fs.open(dataFileNameTurtleJobs,   "w")
    local outLine = ""
    
    -- Loop all records in posListDataList, and write to file
    --logFile.logWrite("#turtleJobsDataList",#turtleJobsDataList)
    for i=1,#turtleJobsDataList do
        turtleJobsData = {}
        turtleJobsData = turtleJobsDataList[i]
        --logFile.logWrite("turtleJobsData",turtleJobsData)
        outLine = turtleJobs.Job2MsgStr(turtleJobsData)
        --logFile.logWrite("outLine",outLine)
        outFile.writeLine(outLine)
    end
    outFile.flush()

    -- Close file
    outFile.close()
end

function turtleJobs.GetJobForTurtle(turtleName)
    --logFile.logWrite("turtleJobs.GetJobForTurtle ",turtleName)
    for i=1,#turtleJobsDataList do
        turtleJobsData = turtleJobsDataList[i]
        --logFile.logWrite("turtleJobsData.TurtleName",turtleJobsData.TurtleName)
        --logFile.logWrite("turtleJobsData.Status",turtleJobsData.Status)
        if(turtleJobsData.TurtleName == turtleName and turtleJobsData.Status=="NEW")then
            --table.remove(turtleJobsDataList,i)
            --logFile.logWrite("Return data")
            return turtleJobsData
        end
    end
    --logFile.logWrite("Return nil")
    return nil
end

function turtleJobs.GetJobFromId(Id)
    --logFile.logWrite("turtleJobs.GetJobFromId",Id)
    --logFile.logWrite("turtleJobsDataList",turtleJobsDataList)
    --logFile.logWrite("#turtleJobsDataList",#turtleJobsDataList)

    for i=1,#turtleJobsDataList do
        turtleJobsData = turtleJobsDataList[i]
        --logFile.logWrite("turtleJobsData.Id",turtleJobsData.Id)
        --logFile.logWrite("turtleJobsData.TurtleName",turtleJobsData.TurtleName)
        --logFile.logWrite("turtleJobsData.Status",turtleJobsData.Status)
        if(turtleJobsData.Id == Id)then
            --logFile.logWrite("Return data")
            return turtleJobsData
        end
    end
    --logFile.logWrite("Return nil")
    return nil
end

function turtleJobs.GetTurtleJobsDataList()
    return turtleJobsDataList
end

function turtleJobs.updateTurtleJobStatus(message)
    --logFile.logWrite("turtleJobs.updateTurtleJobStatus",message)
    fields = {}
    for field in string.gmatch(message, "[^,]+") do
        table.insert(fields, field)
    end
    turtleJobsData = turtleJobs.GetJobFromId(fields[1])
    turtleJobsData.Status = fields[2]
end

function turtleJobs.deleteTurtleJobList(id)
    --logFile.logWrite("in posList.deleteTurtleJobList")
    --logFile.logWrite("id",id)
    --logFile.logWrite("Before #turtleJobsDataList",#turtleJobsDataList)

    table.remove(turtleJobsDataList,tonumber(id))
    --logFile.logWrite("After #turtleJobsDataList",#turtleJobsDataList)
end

function turtleJobs.addTurtleJobToSeveralTurtles(startArea,endArea,numTurtles)
    --logFile.logWrite("In turtleJobs.addTurtleJobToSeveralTurtles")
    --logFile.logWrite("startArea",startArea)
    --logFile.logWrite("endArea",endArea)
    --logFile.logWrite("numTurtles",numTurtles)
    local nextJobNum = #turtleJobsDataList + 1
    --logFile.logWrite("nextJobNum",nextJobNum)

    totalY      = endArea[3] - startArea[3]
    partY       = math.floor(totalY / numTurtles)
    remainderY  = totalY - (partY * numTurtles)
    --logFile.logWrite("totalY",totalY)
    --logFile.logWrite("partY",partY)
    --logFile.logWrite("partY",remainderY)

    startY  = startArea[3]
    endY    = startY + partY + remainderY

    for i=1,numTurtles do
        turtleData                  = turtles.getTurtleDataRecNum(i)
        turtleJobsData              = {}
        turtleJobsData.Id           = nextJobNum
        turtleJobsData.TurtleName   = turtleData.Name
        turtleJobsData.Status       = "NEW"
        turtleJobsData.JobType      = "traverseArea"
        turtleJobsData.x1           = startArea[1]
        turtleJobsData.z1           = startArea[2]
        turtleJobsData.y1           = startY
        turtleJobsData.f1           = startArea[4]
        turtleJobsData.x2           = endArea[1]
        turtleJobsData.z2           = endArea[2]
        turtleJobsData.y2           = endY
        turtleJobsData.f2           = endArea[4]
        turtleJobsData.axisPriority = "xyz"
        table.insert(turtleJobsDataList,turtleJobsData)
        --logFile.logWrite("insert turtleJobsData",turtleJobsData)
        startY      = endY + 1
        endY        = endY + partY
        nextJobNum  = nextJobNum + 1
    end


end


function turtleJobs.Job2MsgStr(turtleJobData)
    if(turtleJobData == nil)then
        return ""
    end
    return         turtleJobData.Id           ..","..
                   turtleJobData.TurtleName   ..","..
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