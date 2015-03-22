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

local fullAutonomous = sequence(
  
  --====================================================--
 
  start(tailSet(73)),                                
  wait(0.1),                                        
  start(liftMacro(16)),
  printcmd("1"),
  wait(0.1),
  start(inOut(1.7)),  
  printcmd("2"),
  wait(.2),
  printcmd("3"),
  setIntake(-.6,.6),
  wait(.2),
  triggerDrive(.6, analogBtn(lidar, 60, true), 1.5),
  triggerWait(analogBtn(lidar, 45, true), .5), 
  --drive(.6, 1.1),
  --wait(.2),
  setIntake(0, 0),                              
  -- has tote                                       
  start(liftMacro(0)),                                    
  wait(1.2),                                         
  start(liftMacro(32)),  
  wait(1),--=--
  --right in front of first trashcan                
  parallel(setIntake(1, 1), drive(0.45, .86)),     
  setIntake(0),                                  
  wait(.32),
  
  --====================================================--
  
   start(tailSet(73)),                                                                     
  --start(liftMacro(16)),
 -- printcmd("1"),
  --wait(0.1),
  start(inOut(1.7)),  
  -- printcmd("2"),
  --wait(.4),   
  --printcmd("3"),
  setIntake(-.6,.6),                                 
  triggerDrive(0.6, analogBtn(lidar, 60, true), 1.5), 
  triggerWait(analogBtn(lidar, 45, true), .5),
  --drive(.6, 1.1),
  --wait(.2),
  setIntake(0, 0),                              
  -- has tote                                       
  start(liftMacro(0)),                                    
  wait(1.2),                                         
  start(liftMacro(32)),  
  wait(1),--=--
  --right in front of second trashcan                
  parallel(setIntake(1, 1), drive(0.45, .86)),     
  setIntake(0),                                  
  wait(.32),
  
  --======================================================--

   start(tailSet(73)),                                                                     
  --start(liftMacro(16)),
 -- printcmd("1"),
  --wait(0.1),
  start(inOut(1.7)),  
  -- printcmd("2"),
  --wait(.4),   
  --printcmd("3"),
  setIntake(-.6,.6),                                 
  triggerDrive(0.6, analogBtn(lidar, 60, true), 1), 
  triggerWait(analogBtn(lidar, 45, true), .5), 
  --drive(.6, 1.1),
  --wait(.2),
  setIntake(0, 0),                              
  -- has tote                                       
  start(liftMacro(0)),                                    
  wait(1.2),                                         
  start(liftMacro(32))

)
return fullAutonomous