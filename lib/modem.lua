 --[[
    modem Function Library
    Developed by Rudi Hansen, Start 2023-03-18

    CHANGE LOG
    2023-05-19 : Initial Version.
]]

local modem = {}

local status = "Idle"

function modem.init()
    rednet.open("back") --enable the modem attached to the back of the PC
end

function modem.receiveMessages()
    while(true) do
        id,message,protocol = rednet.receive() --wait until a message is received
        --logFile.logWrite("modem.receiveMessages()")
        --logFile.logWrite("id",id)
        --logFile.logWrite("message",message)
        --logFile.logWrite("protocol",protocol)
    
        if(protocol == "S") then -- Protocol S = Status Messages
            turtles.messageToTurtleData(id,message)
            monitor.updateTurtleListOnScreen()
        elseif(protocol == "SJ") then -- Protocol ST = Turtle job status
            --logFile.logWrite("modem.receiveMessages","ST",message)
            turtleJobs.updateTurtleJobStatus(message)
            screen.writeTurtleJobListToScreen()
        elseif(protocol == "QB") then -- Protocol QB = Question about Block action
            --logFile.logWrite("Received QB Id=",id)
            monitor.askAboutBlock(id,message)
        elseif(protocol == "QJ") then -- Protocol QJ = Question about Turtle Job
            --logFile.logWrite("Received QJ Id=",id)
            local turtleName = turtles.getTurtleName(id)
            if(turtleName~=nil)then
                --logFile.logWrite("turtleName",turtleName)
                local td = turtleJobs.GetJobForTurtle(turtleName)
                --logFile.logWrite("td",td)
                rednet.send(id,turtleJobs.Job2MsgStr(td),"AJ")
                --logFile.logWrite("Sent reply")
            end
        elseif(protocol == "QL") then -- Protocol QL = Question about location
            local answerString = ""
            answerString = posList.getPosListDataFromName(message)
            --logFile.logWrite("answerString",answerString)
            rednet.send(id,answerString,"AL")
        end
    end
end

return modem