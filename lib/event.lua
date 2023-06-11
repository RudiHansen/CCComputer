 --[[
    event Function Library
    Developed by Rudi Hansen, Start 2023-03-18
]]

local event = {}

function event.getAnyEvent()
    local event, data, x, y = os.pullEvent()
    if(event=="modem_message" or event=="timer" ) then
        return
    end

    logFile.logWrite("screen.getAnyEvent()")
    logFile.logWrite("event",event)
    logFile.logWrite("data",data)
    logFile.logWrite("x",x)
    logFile.logWrite("y",y)

    return event,data,x,y
end

return event