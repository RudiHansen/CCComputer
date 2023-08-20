# CCComputer
Computercraft Computer, used in minecraft for keeping info about and controlling Turtles.
This is a work in progress, so use on your own risk, and please report any bugs you find.
IMPORTANT: I have moved the code to a new repository, so this repository is no longer maintained.
    The new repository is right now Private, but I will make it public when I have working code.

# Plan
Needs to have a list of all active turtles their position and their status.
Needs to be able to send work orders to turtles.

# Next Step


## Rewrite of the code.
I am going to rewrite some of the code, to implement some of the things I have learned, in writing the existing code.

I think I need to make one function to handle all moves of the turtle.
I need this, so there is only one place where all move actions are handled.

### Existing functions:
    move.moveToPos(endPos,axisPriority,dig) : 
        endPos is the position to move to, axisPriority is the axis to prioritize, dig is if the turtle should dig blocks in the way.
        Calculates midPos, two blocks before endPos, based on axisPriority.
        Calls moveHelper.moveToPosWorker to do the actual work, one time with midPos, and one time with endPos.

    moveHelper.moveToPosWorker(endPos,axisPriority,dig) :
        Calls blocks.inspectDig(nextStep,dig) to check if the next step is possible, and if it is, then calls move.move(nextStep) to perform the move.
        But if its not possible it calls move.byPassBlock

    move.traverseArea(turtleJobData,dig) :
        move.moveToPos(startPos,"",false)
        moveHelper.tryMoveDig("N")
        move.byPassBlock(nextMove,areaStart,areaEnd,axisPriority,dig)
        Also calls:
            inventory.checkAll()
            modem.sendTurtleJobProgress()

    move.byPassBlock(nextMove,startPos,endPos,axisPriority,dig) :
        moveHelper.calculateMoves(nextMove,endPos)
        moveHelper.tryMoveDig(sideMove1)
        moveHelper.tryMoveForceDig(sideMove1)
        blocks.inspectDig(origMove,dig)

### Needed functionality:
I need to be able to make a turtle move from one position to another.

But I need to be able to do it in a few different ways.
    Move directly.
    Traverse an area.

And I also need to be able to prioritize the axis to move on.

The turtle need to be able to handle different blocks on the way.
    Ignore : Blocks the Turtle can move through. (Water and Lava)
    Mine   : Blocks that can be mined, depending on a dig parameter.
    Pass   : Blocks that can not be mined, but the turtle should initially try to pass. them.
    Secure : Blocks that can under no circumstances be mined.
    Turtles: Blocks that are other turtles, and should be avoided.
             I may also need a special way to handle this, as turtles move.

The Turtle has to report its position back to the Computer, both to display status, but also so other turtles can avoid it.             

### New functions:
move.moveToPosNew(startPos,endPos,axisPriority,moveMethod,dig) :
    startPos and endPos is the start and end position of the move.
    axisPriority is the axis to prioritize.
    moveMethod is the method to use, direct or area.
        direct : Move directly from startPos to endPos.
        area   : Traverse an area from startPos to endPos.
    dig is if the turtle should dig blocks in the way.

moveHelper.moveToPosWorkerNew(direction, steps, dig) :
    direction is the direction to move, like "N" or "S"
    steps is the number of steps to move.
    dig is if the turtle should dig blocks in the way.

moveHelper.tryMoveNew(direction,dig) :
    direction is the direction to move, like "N" or "S"
    dig is if the turtle should dig blocks in the way.
    In this method, the following checks has to be made to determine if a move can be made.
        Check if the move will take the turtle out of the area.
        Check if a turtle is in the way.
        Check if there is a block in the way, and if there is can it be mined?
    When a move has been made.
        On every move:
            Save Position to file.
        On every x moves:
            Send turtle status to computer.
            Send TurtleJob status to computer.


inventory.unloadAndRefuel()
    This method should be called when the turtle is out of fuel, and needs to go to a fuel station to refuel.
    It should also be called when the turtle is full, and needs to go to a drop off station to unload.

### New data:
settingsData: (Settings for a Computer or Turtle)
    Type        : The type of settings. (Computer, Turtle)
    Depending on the Type the following settings are available.
    Computer:
        Id          : The Id of the Computer.
        ModemSide   : The side of the Computer where the modem is connected.
        MonitorSide : The side of the Computer where the monitor is connected.
    Turtle:
        Id          : The Id of the Turtle.
        ModemSide   : The side of the Turtle where the modem is connected.
        MaxFuelLevel: The maximum fuel level of the Turtle.
        MinFuelLevel: The minimum fuel level of the Turtle.
        RefuelItems : The number of items the Turtle should use pr. refuel.
        MinFreeSlots: The minimum number of free slots the Turtle should have before it goes to unload.

turtleData: (Data about a turtle)
    Id      : The Id of the turtle.
    Name    : The name of the turtle. (os.getComputerLabel())
    Status  : The status of the turtle. (Idle, Working, Moving, Waiting, Error, Warning, Unload)
    PosX    : The X position of the turtle.
    PosZ    : The Z position of the turtle.
    PosY    : The Y position of the turtle.
    PosF    : What direction the turtle is facing.
    Inv     : Free Inventory slots.
    Fuel    : Fuel level. (turtle.getFuelLevel())

turtleJobData:  (Data about a job)
    Id          : The Job Id.
    TurtleName  : The name of the turtle that is working on the job.
    Status      : The status of the job. (New, Running, Paused, Done, Error)
    JobType     : The type of job. (MoveTo, ClearArea, MoveHome, Unload)
    AxisPriority: The axis to prioritize when moving.
    StartX      : The X position of the start of the job.
    StartZ      : The Z position of the start of the job.
    StartY      : The Y position of the start of the job.
    StartF      : What direction the turtle is facing at the start of the job.
    EndX        : The X position of the end of the job.
    EndZ        : The Z position of the end of the job.
    EndY        : The Y position of the end of the job.
    EndF        : What direction the turtle should be facing at the end of the job.
    LastX       : The X position of the turtle at the last save.
    LastZ       : The Z position of the turtle at the last save.
    LastY       : The Y position of the turtle at the last save.
    LastF       : What direction the turtle was facing at the last save.

posData: (Data about a position)
    Id      : The Id of the position.
    Name    : The name of the position.
    PosX    : The X position of the position.
    PosZ    : The Z position of the position.
    PosY    : The Y position of the position.
    PosF    : The direction of the position.

blockData: (Data about a block)
    Name    : The name of the block.
    Action  : The action to perform on the block. (Ignore, Mine, Pass, Secure, Turtle)

## Add New job.
Its making overlapping areas with these parameters.
2,-78,68,N
35,-100,118,N
4
x

## Turtle blocking Turtle
Some times Turtles can block each other, especially if more than one of them tries to Empty/Refuel at the same time.
I think the problem is some where in blocks.inspectDig(direction,dig)
Some where in line 44
But to fix this I need to make something where you can ask for other turtles, status and position.


## Line up turtle jobs on restart?
When the computer restarts, it should line up all the turtles, and then start the jobs again.
But this is a part that might need a larger change in the code, so I will leave it for now.

## modem.askAboutStopCommand() implement timeout
In the modem.askAboutStopCommand() I have a timeout functionality.
I need to check if i need this in other places, and if I do, then I need to make a function for it.

## TestDisplayTurtleMinerStatus.exe
Consider adding the list of Turtles running, and their status, to the display. (TurtleJobs.dat)
General rework of layout of the app.

## Possible problem in move.traverseArea
After implementing that the turtle can resume from where it last stopped.
I assumed that the z axis is the one that should be set to progress value.
But I am not sure how this will work if the turtle is working with another axisPriority.

## Problem in move.byPassBlock
Some times the turtle gets into a loop trying to pass first one way, and the the other, and does this forever.
Also perhaps I need to make a check for if the turtle moves out of its area, since it should newer do that.
And perhaps also a check for if the turtle gets too far away from the starting position.

## Edit turtle job
Change to Edit turtle job, I would like to be able to change the Job data, like changing the starting or ending coordinates.

## Job Creation
Think of adding an option where you can manually select the area size for each Turtle.
So lets say you are creating a job for 4 turtles, divided vertically.
If you choose Auto divide, then the computer will divide the area into 4 equal parts.
If you choose Manual divide, then you will be prompted for first area value, with a suggestion of the value, then next area value, and so on.
Like you have a 100x100x100 area:
Computer prompts area 1 = 25 you enter 30
Computer prompts area 2 = 23 you enter 24
Computer prompts area 3 = 23 you press enter
Computer prompts area 4 = 23 you press enter.
Not the areas are divided into 30,24,23,23.


## Problem with job creation.
In turtleJobs.addTurtleJobToSeveralTurtles, right now there might be a problem with the job areas overlaying in some cases.
The problem has something to do with this line:
```lua startPos      = endPos - 1 ```
That might not have to be minus 1, depending on the direction of the area.

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

## Turtle job progress
Not sure if this is possible, but would also be nice if turtles reported back the process of a job, so if the turtle was stopped it could resume.
Start by making turtles report progress on a job, using new protocol "SP" (Status Progress)
Then I need to change the turtles to resume a job from the last position now saved in turtleJobData.

## Send Turtle STOP from Computer
Would like to make it possible to send a STOP work command from the Computer, to ether one or all Turtles.
But for now the local STOP file should also stay there as a backup solution.
Turtle : Change inventory.checkForStopCommand() to ask server for STOP command.
Computer : modem.receiveMessages() add protocol QS for Question about STOP Command.
Computer : screen.editTurtleJobList() needs to add possibility to set a job to status STOP.
Computer : screen.editTurtleJobList() needs to be able to change status of all jobs.

