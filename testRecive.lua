local monitor = peripheral.wrap("left")

rednet.open("back") --enable modem on the right side of the PC

-- Clear Monitor and print header line.
monitor.clear()
monitor.setTextScale(1) -- 1 Seems to be the standard, 0.5 makes the text smaller
local monitorSizeX, monitorSizeY = monitor.getSize()
monitor.setCursorPos(1,monitorSizeY)
monitor.write(monitorSizeX.." "..monitorSizeY)


monitor.setCursorPos(1,1)
monitor.write("Name")
monitor.setCursorPos(10,1)
monitor.write("Position")
monitor.setCursorPos(25,1)
monitor.write("Fuel Level")

while(true) do
    id,message = rednet.receive() --wait until a mesage is received

    local messageSplit = {}
    for element in string.gmatch(message, "[^;]+") do
        table.insert(messageSplit,element)    
    end

    if(messageSplit[1]=="TurtleStatus")then
        monitor.setCursorPos(1,2)
        monitor.write(messageSplit[2])
        monitor.setCursorPos(10,2)
        monitor.write(messageSplit[3].." " .. messageSplit[4] .. " " .. messageSplit[5] .. " " .. messageSplit[6])
        monitor.setCursorPos(25,2)
        monitor.write(messageSplit[7])
    end


    -- Label
    -- FuelLevel
    -- x
    -- y
    -- z
    -- f

end