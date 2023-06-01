mon = peripheral.wrap("left")

while true do
    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setTextScale(5)
    mon.setCursorPos(4,2)
    mon.setTextColor(colors.red)
    mon.write("Touch Me!")
    event, side, x, y = os.pullEvent("monitor_touch")
    print(event .. " => Side: " .. tostring(side) .. ", " .. "X: " .. tostring(x) .. ", " .. "Y: " .. tostring(y))
    if (x > 4 and x < 12 and y == 2) then
        mon.setBackgroundColor(colors.blue)
        mon.clear()
        mon.setCursorPos(4,2)
        mon.setTextColor(colors.yellow)
        mon.write("That's nice ;-)")
        sleep(2)
    end
end