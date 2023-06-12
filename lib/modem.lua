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
        --logFile.logWrite("id",id)
        --logFile.logWrite("message",message)
        --logFile.logWrite("protocol",protocol)
    
        if(protocol == "S") then -- Protocol S = Status Messages
            turtles.messageToTurtleData(id,message)
            monitor.updateTurtleListOnScreen()
        elseif(protocol == "QB") then -- Protocol QB = Question about Block action
            monitor.askAboutBlock(id,message)
        end
    end
end

return modem