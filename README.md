# CCComputer
Computercraft Computer, used in minecraft for keeping info about and controlling Turtles.
This is a work in progress, so use on your own risk, and please report any bugs you find.

# Plan
Needs to have a list of all active turtles their position and their status.
Needs to be able to send work orders to turtles.

# Next Step
Still Missing:

## Turtle blocking Turtle
Some times Turtles can block each other, especially if more than one of them tries to Empty/Refuel at the same time.
Need to figure out some way to avoid this from happening.
Perhaps something about asking the computer if its ok to go, and then the computer checks if someone else if blocking. If the answer is someone is blocking, then wait 30 sec and try again.

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

