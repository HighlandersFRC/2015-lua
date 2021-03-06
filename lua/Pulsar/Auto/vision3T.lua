local drive = require"Pulsar.Auto.DriveForward"
local turn = require"Pulsar.Auto.SpinTurn"
local intake = require "Pulsar.Auto.intake"
local sequence = require"command.Sequence"
local spin = require "Pulsar.Auto.SpinTurn"
local liftMacro = require "Pulsar.Auto.lifterUpDown"
local wait = require "command.Wait"
local start = require "command.Start"
local inOut = require "Pulsar.Auto.moveInOutAuto"
local tailSet = require "Pulsar.TailPosition"
local printcmd = require "command.Print"
local parallel = require "command.Parallel"
local triggerDrive = require "Pulsar.Auto.TriggeredDrive"
local setIntake = require "Pulsar.Auto.SetIntake"
local analogBtn = require "AnalogButton"
local lidar = require "ArduLidar"
local triggerWait = require "command.TriggerWait"
local chaseVision = require"Pulsar.Auto.ChaseVision"
robotMap.navX:ZeroYaw()

return sequence(

  -- mi nombre es Tyler
  start(tailSet(80)),                                 
  start(liftMacro(16)),
  start(inOut(1)),  
  turn(-25),
  chaseVision(),                            
  -- has tote                                       
  start(liftMacro(0)),                                    
  turn(23),
  drive(.75, .41),                                
  wait(.1),
  turn(0),
  start(liftMacro(16)),
  drive(.7,.8),

  --===================================--

  start(tailSet(80)),                                  
  start(liftMacro(16)),
  start(inOut(1)),  
  turn(-25),
  chaseVision(),                                
  -- has tote                                       
  start(liftMacro(0)),                                    
  turn(23),
  drive(.75, .41),                                
  wait(.1),
  turn(0),
  start(liftMacro(16)),
  drive(.7, .8),

  --==========================================--

  start(tailSet(80)),                                
  start(liftMacro(16)),
  start(inOut(1)),  
  turn(-25),
  chaseVision(),                              
  -- has tote                                       
  start(liftMacro(12)),
  turn(90),
  start(liftMacro(8)),
  drive(1, 1),
  setIntake(1,-1),
  drive(1, .3),
  wait(.5),
  setIntake(0, 0)
  
  
)
