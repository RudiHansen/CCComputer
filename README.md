# CCComputer
Computercraft Computer, used in minecraft for keeping info about and controlling Turtles.

# Plan
Needs to have a list of all active turtles their position and their status.
Needs to be able to send work orders to turtles.

# Saved PosList.dat
1,Miner1,75,36,63,S
2,Miner2,77,36,63,S
3,Fuel,73,37,63,N
4,DropOff,74,37,63,N

# Data Structures
TurtleData
TurtleId    Name    Status  PosX    PosZ    PosY    PosF    Inv Fuel

TurtleJobData
TurtleId    Status  JobType FromX   FromZ   FromY   ToX ToZ ToY Direction   AxisPriority

# Next Step
Still Missing:

Look into the process about sending jobs to turtles.
I would like to be able to give the computer an area to clear, and then it should based on how meany turtles are available be able to distribute jobs to them.




Also need to work on block avoidance, it is simply not good enough as it is now.


I was thinking that perhaps I should look into separating thinks into different processes that may be able to run at the same time, using parallel.waitForAll
1. Process that receives modem messages, and processes them modem.receiveMessages()
    Protocol S   : Status updates from Turtles  (Done)
    Protocol QB  : Question about blocks        (Done)
    Protocol QJ  : Question about Jobs          (Done)
    Protocol QL  : Question about locations     (Done)
    Protocol QS  : Question about STOP Command  (Not made)
    Protocol QBL : Question about block lists   (Not made)

2. Process that handles the monitor, and perhaps also monitor_touch events
    Screen for Menu                             (Done)
    Screen for Turtle List                      (Done)
    Screen for questions about blocks           (Done)
    Screen for stopping a turtle

3. Process that reads jobs for turtles from files and sends them to the turtles.
    MoveTo Job (x,z,y,f,axisPriority)                               (Done)
    ClearArea Job (fromArea,toArea,axisPriority)                    (Done)
    MoveHome Job (axisPriority)                                     (Done)
    Continue ClearArea Job (fromArea,toArea,beginFrom,axisPriority)

In Main
    event.getAnyEvent() fix the return variables to be more saying
    Handle protocol on rednet_message
    Handle different kinds of input from monitor_touch, something depending on what screen is showing.

Sending jobs to turtles, this is kind of important.
    Think also here I need data files, to read from.

For rednet_message
    DONE : Receiving turtle data
    Receive and answer questions, be ops on how to handle more than one question at the same time, no idea how

Some data
    Handle turtle home locations
    Handle fuel pickup location
    Handle drop off location
    Think I need a dat file for all locations
    And later I need to be able to have multiple fuel and drop off locations, and only send nearest to turtle.
    Also need to send block_data to turtles in some way.
