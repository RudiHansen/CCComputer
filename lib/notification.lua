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
        fs.delete(notificationFileName)
    end
end

return notification