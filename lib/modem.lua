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
        end

        --[[
        if(protocol == "QB") then -- Protocol QB = Question about Block action
            monitor.setCursorPos(1,10)
            monitor.write("Turtle " .. id .. " asks.")
            monitor.setCursorPos(1,11)
            monitor.write("What to do with block:")
            monitor.setCursorPos(1,12)
            monitor.write(message)
    
            monitor.setCursorPos(1,14)
            monitor.write("mine")
    
            monitor.setCursorPos(10,14)
            monitor.write("ignore")
    
            monitor.setCursorPos(20,14)
            monitor.write("pass")
    
            event, side, x, y = os.pullEvent("monitor_touch")
            if (x > 0 and x < 10) then
                rednet.send(id,"mine")
            elseif (x > 10 and x < 20) then
                rednet.send(id,"ignore")
            elseif (x > 20 and x < 30) then
                rednet.send(id,"pass")
            end
    
            monitor.setCursorPos(1,10)
            monitor.clearLine()
            monitor.setCursorPos(1,11)
            monitor.clearLine()
            monitor.setCursorPos(1,12)
            monitor.clearLine()
            monitor.setCursorPos(1,14)
            monitor.clearLine()
    
        end
        ]]
    end
end

return modem