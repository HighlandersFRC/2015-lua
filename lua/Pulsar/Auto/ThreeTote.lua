print"AutoTest"

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

robotMap.navX:ZeroYaw()

return sequence(

  start(tailSet(73)),                                
  wait(0.1),  
  start(liftMacro(16)),
  wait(0.1),
  start(inOut(1.55)),  
  printcmd("2"),
  turn(-17),
  wait(.2),
  printcmd("3"),
  setIntake(-.6,.6),
  wait(.2),
  ----test vvv
  drive(.4, .75),
  wait(.4),
  -------
  setIntake(0, 0),                              
  -- has tote                                       
  start(liftMacro(0)),                                    
  wait(.8),
  turn(23),
  drive(.65, .6),                                
  wait(.15),
  turn(0),
  start(liftMacro(16)),
  drive(.6,.6)

  --===================================--

  --[[start(tailSet(73)),                                
  wait(0.1),  
  printcmd("1"),
  wait(0.1),
  start(inOut(1.55)),  
  printcmd("2"),
  turn(-15),
  wait(.2),
  printcmd("3"),
  setIntake(-.6,.6),
  wait(.2),
  triggerDrive(.6, analogBtn(lidar, 53, true), 1.5),
  triggerWait(analogBtn(lidar, 45, true), .6), 
  setIntake(0, 0),                              
  -- has tote                                       
  start(liftMacro(0)),                                    
  wait(.8),
  turn(23),
  drive(.65, 1),                                
  wait(.15),
  turn(0),
  start(liftMacro(16)),
  drive(.55,.55),

  --==========================================--

  start(tailSet(73)),                                
  wait(0.1),  
  printcmd("1"),
  wait(0.1),
  start(inOut(1.55)),  
  printcmd("2"),
  turn(-17),
  wait(.2),
  printcmd("3"),
  setIntake(-.6,.6),
  wait(.2),
  triggerDrive(.6, analogBtn(lidar, 53, true), 1.5),
  triggerWait(analogBtn(lidar, 45, true), .6), 
  setIntake(0, 0),                              
  -- has tote                                       
  start(liftMacro(0)),                                    
  wait(.8),
  start(liftMacro(16)),
  turn(90)--]]
  
)