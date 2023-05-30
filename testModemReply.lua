local monitor = peripheral.wrap("left")

rednet.open("back") --enable modem on the right side of the PC

monitor.clear()
while(true) do
    id,message, foo = rednet.receive() --wait until a mesage is received
    monitor.setCursorPos(1,1)
    monitor.write(id)
    monitor.setCursorPos(1,2)
    monitor.write(message)
    monitor.setCursorPos(1,3)
    monitor.write(foo)

    rednet.send(id,"Reply")
end
