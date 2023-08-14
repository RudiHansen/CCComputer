 --[[
    notification Function Library   
    Developed by Rudi Hansen on 2023-05-22
]]

local notification = {}

local notificationFileName = "notification.txt"

function notification.createNotificationFile(message)
    local notificationFile = fs.open(notificationFileName, "w")
    notificationFile.writeLine(message)
    notificationFile.close()
end

function notification.removeNotificationFile()
    if(fs.exists(notificationFileName)) then
        local notificationFile = fs.open(notificationFileName, "w")
        notificationFile.writeLine("EMPTY")
        notificationFile.close()
        end
end

function notification.notifyBasedOnStatus(id, status, protocol)
    if(protocol == "S") then
        if(status == "ERROR") then
            notification.createNotificationFile("Turtle " .. id .. " reported an error.")
        elseif(status == "WARNING") then
            notification.createNotificationFile("Turtle " .. id .. " reported a warning.")
        end
    elseif(protocol == "SJ") then
        if(status == "DONE") then
            notification.createNotificationFile("Turtle " .. id .. " finished a job.")
        end
    elseif(protocol == "QB") then
        notification.createNotificationFile("Turtle " .. id .. " asked about a block.")
    end
end

return notification