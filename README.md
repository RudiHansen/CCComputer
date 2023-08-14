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
Id  TurtleName  Status  JobType FromX   FromZ   FromY   ToX ToZ ToY Direction   AxisPriority
                NEW     moveToPos
                RUN     traverseArea
                DONE    moveHome


# Next Step
Still Missing:

## Turtle job progress
Not sure if this is possible, but would also be nice if turtles reported back the process of a job, so if the turtle was stopped it could resume.

## Turtle blocking Turtle
Some times Turtles can block each other, especially if more than one of them tries to Empty/Refuel at the same time.
Need to figure out some way to avoid this from happening.
Perhaps something about asking the computer if its ok to go, and then the computer checks if someone else if blocking. If the answer is someone is blocking, then wait 30 sec and try again.

## Send Turtle STOP from Computer
Would like to make it possible to send a STOP work command from the Computer, to ether one or all Turtles.
But for now the local STOP file should also stay there as a backup solution.

## Edit turtle job
Change to Edit turtle job, I would like to be able to change the Job data, like changing the starting or ending coordinates.

## Error in screen handler
Possible error in screen.screenHandler()
It seems that its not possible to add a new location to the posList, right now when i press a to add nothing happens.

## Block type syncronize
Implement system for Turtles to synchronies block lists.

## JobType FillBlocksArea
New JobType : FillBlocksArea, Go through an area and put down block.
Think the first version should assume the area is cleared, and only put down one block type.
Think it has to go to an X,Z and then go down to lowest Y point, and then go up til top Y and place blocks.
Needs to handle 2 types of blocks, like Stone and Dirt, and fill Stone first and Dirt last 3 levels.

## JobType ReplaceBlockArea
New JobType : ReplaceBlockArea, replace block in an area under the Turtle, like replacing all non stone blocks with stone.

## JobType PlaceTorchArea
New JobType : PlaceTorchArea, place torches in an area with a giving spacing, to prevent mob spawning.

## Modem protocol issues
Modem protocol, there is a problem when multiple turtles tries to communicate with the computer simultaneously.
Looks like if one Turtle is asking about a block action, then while an answer is not sent other questions are not answered.
So seems like I need to come up with some sort of a queuing system.
*** No the Temp Fix will not work**
*** Temp Fix for this could be some way of sending a blank message to a turtle, but I would also have to change all places in the code where modem.send is called to change turtles status to "COMM" so I can see the turtle is waiting for an reply (Done set status COM?)**

## Pocket Computer
Pocket Computer, can it be used for anything?
Perhaps it could be used to manually control the Turtle if it is stuck?







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

# Tasks Done
## Notifications
I would like the computer to send me a notification on my phone, when ewer the Turtle is stuck, or done working.
So I need the computer to save a file when there is a notification, and then use powerShell to send a notification.
Look at the C:\Spil\SendNotificationIFTTTT.ps1 example.
I am having some problems with the Phone notifications, so perhaps I should make a program for the computer instead that notifies me, like the TestDisplay program I already made.
Did this, but one thing is missing, a notification when a turtle is done with work.
I have some notifications now in monitor.writeTurtleDataOnLine, but Idle does not work there, and perhaps all notifications should be moved to modem.receiveMessages
