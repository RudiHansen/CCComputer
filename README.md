# CCComputer
Computercraft Computer, used in minecraft for keeping info about and controlling Turtles.

# Plan
Needs to have a list of all active turtles their position and their status.
Needs to be able to send work orders to turtles.

# Next Step
Have first to make some changes to the Main computer.
Has to have a main.lua main controller program.
Has to maintain a table of Turtles
Make screen control module
    1 : Main screen with menu
    2 : Show Turtle list
    3 : Show Turtle questions

Still Missing:
I was thinking that perhaps I should look into separating thinks into different processes that may be able to run at the same time, using parallel.waitForAll
1. Process that receives modem messages, and processes them modem.receiveMessages()
    Protocol S   : Status updates from Turtles  (Done)
    Protocol QB  : Question about blocks        (Done)
    Protocol QJ  : Question about Jobs          (Done)
    Protocol QL  : Question about locations     (Not made)
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
