local drive = require"Pulsar.Auto.DriveForward"
local turn = require"Pulsar.Auto.SpinTurn"
local intake = require "Pulsar.Auto.intake"
local sequence = require"command.Sequence"
local spin = require "Pulsar.Auto.SpinTurn"
local liftMacro = require "Pulsar.Auto.liftMacro"
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

local fullAutonomous = sequence(
  --------------------------------------------------------
  --====================================================--
  -----------------------------------------------------=--
  start(tailSet(73)),                                --=--
  wait(0.1),                                         --=--
  parallel(liftMacro(16), inOut(1.35, 1)),           --=--
  wait(.4),                                          --=--
  setIntake(-.375, false),                           --=--
  triggerDrive(0.37, analogBtn(lidar, 45, true), 2), --=--
  setIntake(0, false),                               --=--
  -- has tote                                        --=--
  liftMacro(.05),                                    --=--
  wait(0.4),                                         --=--
  liftMacro(31),                                     --=--
  --right in front of first trashcan                 --=--
  parallel(setIntake(1, true), drive(0.35, 1)),      --=--
  setIntake(0),                                      --=--
  wait(.4),                                          --=--
  -----------------------------------------------------=--
  --====================================================--
  --------------------------------------------------------
  
  -- IN FRONT OF SECOND TOTE
  
  --------------------------------------------------------
  --====================================================--
  -----------------------------------------------------=--
  start(tailSet(73)),                                --=--
  wait(0.1),                                         --=--
  inOut(1.35, 1),                                    --=--
  wait(.4),                                          --=--
  setIntake(-.375),                                  --=--
  triggerDrive(0.37, analogBtn(lidar, 45, true), 2), --=--
  setIntake(0),                                      --=--
  -- has tote                                        --=--
  liftMacro(.05),                                    --=--
  wait(0.4),                                         --=--
  liftMacro(31),                                     --=--
  --right in front of second trashcan                --=--
  parallel(setIntake(1, true), drive(0.35, 1)),      --=--
  setIntake(0),                                      --=--
  printcmd("7"),                                     --=--
  wait(.4),                                          --=--
  -----------------------------------------------------=--
  --====================================================--
  --------------------------------------------------------

  -- IN FRONT OF THIRD TOTE

  ---------------------------------------------------------
  --=====================================================--
  ------------------------------------------------------=--
  start(tailSet(73)),                                 --=--
  wait(0.1),                                          --=--
  inOut(1.35, 1),                                     --=--
  wait(.4),                                           --=--
  setIntake(-.375),                                   --=--
  triggerDrive(0.37, analogBtn(lidar, 45, true), 2),  --=--
  setIntake(0),                                       --=--
  -- has tote                                         --=--
  liftMacro(.05),                                     --=--
  wait(0.4),                                          --=--
  liftMacro(3)                                        --=--
  --in front of third trashcan                        --=--
  ------------------------------------------------------=--
  --=====================================================--
  ---------------------------------------------------------
)
return fullAutonomous