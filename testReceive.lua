local monitor = peripheral.wrap("left")

rednet.open("back") --enable modem on the right side of the PC

-- Clear Monitor and print header line.
monitor.clear()
monitor.setTextScale(1) -- 1 Seems to be the standard, 0.5 makes the text smaller
local monitorSizeX, monitorSizeY = monitor.getSize()
monitor.setCursorPos(1,monitorSizeY)
monitor.setTextColor(colors.white)
monitor.write(monitorSizeX.." "..monitorSizeY)


monitor.setCursorPos(1,1)
monitor.write("Name")

monitor.setCursorPos(10,1)
monitor.write("Status")

monitor.setCursorPos(18,1)
monitor.write("Position")

monitor.setCursorPos(35,1)
monitor.write("Fuel")

while(true) do
    id,message,protocol = rednet.receive() --wait until a message is received
    print(id)
    print(message)
    print(protocol)

    if(protocol == "S") then -- Protocol S = Status Messages
        local messageSplit = {}
        for element in string.gmatch(message, "[^;]+") do
            table.insert(messageSplit,element)    
        end

        if(messageSplit[1]=="TurtleStatus")then
            monitor.setCursorPos(1,2)
            monitor.write(messageSplit[2].."  ")

            monitor.setCursorPos(10,2)
            monitor.write(messageSplit[8].."   ")

            monitor.setCursorPos(18,2)
            monitor.write(messageSplit[3].." " .. messageSplit[4] .. " " .. messageSplit[5] .. " " .. messageSplit[6].."   ")

            monitor.setCursorPos(35,2)
            monitor.write(messageSplit[7].."   ")
        end
    end

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

end