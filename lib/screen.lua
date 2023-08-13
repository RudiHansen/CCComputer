 --[[
    screen Function Library
    Developed by Rudi Hansen, Start 2023-06-22
]]

local screen = {}

local termSizeX, termSizeY
local activeScreen

function screen.init()
    termSizeX, termSizeY = term.getSize()
    logFile.logWrite("termSizeX",termSizeX)
    logFile.logWrite("termSizeY",termSizeY)
end

function screen.screenHandler()
    --logFile.logWrite("In screen.screenHandler()")
    screen.drawMainScreen()
    activeScreen = "MAIN"

    while(true) do
        local event, key, isHeld = os.pullEvent("key")
        logFile.logWrite("Key pressed=",keys.getName(key))
        logFile.logWrite("activeScreen",activeScreen)
        os.pullEvent("char") -- Pull the key press from the buffer so it does not show up on screen

        if(activeScreen=="MAIN" and keys.getName(key)=="one")then
            activeScreen = "POSLIST"
            screen.drawPosList()
        elseif(activeScreen=="MAIN" and keys.getName(key)=="two")then
            activeScreen = "TURTLEJOBLIST"
            screen.drawTurtleJobList()
        elseif(activeScreen=="MAIN" and keys.getName(key)=="q")then
            monitor.clear()
            term.clear()
            term.setCursorPos(1,1)
            return
        elseif(activeScreen=="POSLIST" or activeScreen=="TURTLEJOBLIST" and keys.getName(key)=="b")then
            screen.drawMainScreen()
            activeScreen = "MAIN"
        elseif(activeScreen=="POSLIST" and keys.getName(key)=="e")then
            screen.editPosList()
            activeScreen = "POSLIST"
            screen.drawPosList()
        elseif(activeScreen=="POSLIST" and keys.getName(key)=="a")then
            logFile.logWrite("Calling addPosList")
            screen.addPosList()
            activeScreen = "POSLIST"
            screen.drawPosList()
        elseif(activeScreen=="POSLIST" and keys.getName(key)=="d")then
            screen.deletePosList()
            activeScreen = "POSLIST"
            screen.drawPosList()
        elseif(activeScreen=="TURTLEJOBLIST" and keys.getName(key)=="e")then
            screen.editTurtleJobList()
            activeScreen = "TURTLEJOBLIST"
            screen.drawTurtleJobList()
        elseif(activeScreen=="TURTLEJOBLIST" and keys.getName(key)=="a")then
            screen.addTurtleJobList()
            activeScreen = "TURTLEJOBLIST"
            screen.drawTurtleJobList()
        elseif(activeScreen=="TURTLEJOBLIST" and keys.getName(key)=="d")then
            screen.deleteTurtleJobList()
            activeScreen = "TURTLEJOBLIST"
            screen.drawTurtleJobList()
        end
        screen.yield()
    end
end

function screen.yield()
    os.queueEvent("fake")
    os.pullEvent("fake")
end

function screen.drawMainScreen()
    -- Clear Screen setup
    term.clear()
    term.setTextColor(colors.white)

    screen.centerTextOnLine("********** MAIN **********",1)
    screen.writeAtPos("1 : Show Pos List",10,3)
    screen.writeAtPos("2 : Show Turtle Job List",10,4)
    screen.writeAtPos("q : Quit",10,6)
end

function screen.drawPosList()
    term.clear()
    term.setTextColor(colors.white)

    screen.centerTextOnLine("********** Pos List **********",1)
    screen.writeAtPos("Id",1,3)
    screen.writeAtPos("Name",5,3)
    screen.writeAtPos("PosX",16,3)
    screen.writeAtPos("PosZ",22,3)
    screen.writeAtPos("PosY",28,3)
    screen.writeAtPos("Face",34,3)

    screen.drawLineOnLine(18)
    screen.centerTextOnLine("B-BACK E-Edit D-Delete A-Add",19)

    screen.printPosListToScreen()    
end

function screen.drawTurtleJobList()
    term.clear()
    term.setTextColor(colors.white)

    screen.centerTextOnLine("********** TurtleJob List **********",1)
    screen.writeAtPos("Id"          ,1,3)
    screen.writeAtPos("TurtleName"  ,4,3)
    screen.writeAtPos("Status"      ,15,3)
    screen.writeAtPos("JobType"     ,22,3)

    screen.drawLineOnLine(18)
    screen.centerTextOnLine("B-BACK E-Edit D-Delete A-Add",19)
    screen.writeTurtleJobListToScreen()
end

function screen.printPosListToScreen()
    local startLine = 4
    local posList   = posList.getPosListDataList()
    local posListData = {}
    --logFile.logWrite("#posList",#posList)

    if(activeScreen=="POSLIST") then
        --logFile.logWrite("activeScreen",activeScreen)

        for i=1,#posList do
            posListData = {}
            posListData = posList[i]
            --logFile.logWrite("posListData",posListData)
            screen.writePosListDataOnLine(posListData,startLine)
            startLine = startLine + 1
        end

    end
end

function screen.writePosListDataOnLine(posListData,line)
    screen.writeAtPos(posListData.Id,1,line)
    screen.writeAtPos(posListData.Name,5,line)
    screen.writeAtPos(posListData.PosX,16,line)
    screen.writeAtPos(posListData.PosZ,22,line)
    screen.writeAtPos(posListData.PosY,28,line)
    screen.writeAtPos(posListData.Face,34,line)
end

function screen.writeTurtleJobListToScreen()
    local startLine = 4
    local turtleJobData = {}
    local data          = turtleJobs.GetTurtleJobsDataList()
    --logFile.logWrite("#data",#data)
    
    if(activeScreen=="TURTLEJOBLIST") then
        for i=1,#data do
            turtleJobData = {}
            turtleJobData = data[i]
            --logFile.logWrite("turtleJobData",turtleJobData)
            screen.writeTurtleJobDataOnLine(turtleJobData,startLine)
            startLine = startLine + 1
        end
    end
end

function screen.writeTurtleJobDataOnLine(turtleJobData,line)
    screen.writeAtPos(turtleJobData.Id,         1,line)
    screen.writeAtPos(turtleJobData.TurtleName, 4,line)
    screen.writeAtPos(turtleJobData.Status,     15,line)
    screen.writeAtPos(turtleJobData.JobType,    22,line)
end

function screen.editPosList()
    --logFile.logWrite("In screen.editPosList")
    screen.writeAtPos("Enter the edited record, fields separated with ,",1,16)
    screen.writeAtPos("Record : ",1,17)
    local input = read()
    screen.clearLine(16)
    screen.clearLine(17)
    --logFile.logWrite("input",input)
    posList.editPosList(input)
end

function screen.addPosList()
    logFile.logWrite("In screen.addPosList")
    screen.writeAtPos("Enter the new record, fields separated with ,",1,16)
    screen.writeAtPos("Record : ",1,17)
    local input = read()
    screen.clearLine(16)
    screen.clearLine(17)
    logFile.logWrite("input",input)
    posList.addPosList(input)
end

function screen.deletePosList()
    --logFile.logWrite("In screen.deletePosList")
    screen.writeAtPos("Enter Id of the record to delete",1,16)
    screen.writeAtPos("Record : ",1,17)
    local input = read()
    screen.clearLine(16)
    screen.clearLine(17)
    --logFile.logWrite("input",input)
    posList.deletePosList(input)
end

function screen.editTurtleJobList()
    --logFile.logWrite("In screen.editTurtleJobList")
    screen.writeAtPos("You can only edit status on record to NEW",1,15)
    screen.writeAtPos("Enter the record to change status on",1,16)
    screen.writeAtPos("Record : ",1,17)
    local input = read()
    screen.clearLine(15)
    screen.clearLine(16)
    screen.clearLine(17)
    --logFile.logWrite("input",input)
    turtleJobs.updateTurtleJobStatus(input..",NEW")
end

-- This method has to ask the user for an area to mine, and then divide that area into
-- jobs for all the turtles to work on.
-- So if there are 2 turtles, each of them had to mine part of the area.
function screen.addTurtleJobList()
    --logFile.logWrite("In screen.addTurtleJobList")
    term.clear()
    term.setTextColor(colors.white)

    screen.centerTextOnLine("********** TurtleJob Add **********",1)
    screen.writeAtPos("Enter start of the area to mine, x,z,y,face",1,3)
    screen.writeAtPos("Start :",1,4)
    local startArea = read()
    startArea = util.splitString(startArea)
    --logFile.logWrite("startArea",startArea)

    screen.writeAtPos("Enter end of the area to mine, x,z,y,face",1,5)
    screen.writeAtPos("Start :",1,6)
    local endArea = read()
    endArea = util.splitString(endArea)
    --logFile.logWrite("endArea",endArea)

    screen.writeAtPos("Enter number of turtles available",1,7)
    screen.writeAtPos("#Turtles :",1,8)
    local numTurtles = read()
    numTurtles = tonumber(numTurtles)
    --logFile.logWrite("numTurtles",numTurtles)

    screen.writeAtPos("Enter split axis y=horizontal or x=vertical",1,9)
    screen.writeAtPos("#SplitAxis :",1,10)
    local splitAxis = read()

    turtleJobs.addTurtleJobToSeveralTurtles(startArea,endArea,splitAxis,numTurtles)
end

function screen.deleteTurtleJobList()
    --logFile.logWrite("In screen.deleteTurtleJobList")
    screen.writeAtPos("Enter Id of the record to delete",1,16)
    screen.writeAtPos("Record : ",1,17)
    local input = read()
    screen.clearLine(16)
    screen.clearLine(17)
    --logFile.logWrite("input",input)
    turtleJobs.deleteTurtleJobList(input)
end

function screen.centerTextOnLine(text,line)
    local textPos = ((termSizeX - string.len(text)) / 2) + 1
    --logFile.logWrite("textPos",textPos)

    term.setCursorPos(textPos,line)
    term.write(text)
end

function screen.drawLineOnLine(line)
    term.setCursorPos(1,line)
    term.write(string.rep("-",termSizeX))
end

function screen.writeAtPos(text,x,y)
    term.setCursorPos(x,y)
    term.write(text)
end

function screen.clear()
    term.clear()
end

function screen.clearLine(line)
    term.setCursorPos(1,line)
    term.clearLine()
end

return screen