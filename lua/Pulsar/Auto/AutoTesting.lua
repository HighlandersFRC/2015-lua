print"AutoTest"

--[[local drive = require"Pulsar.Auto.DriveForward"
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

  start(tailSet(80)),                                 
  start(liftMacro(16)),
  start(inOut(1)),  
  setIntake(-.6,.6),
  ----test vvv
  drive(.25, 1.15),
  wait(.35),
  -------
  setIntake(0, 0),                              
  -- has tote                                       
  start(liftMacro(0)),                                    
  turn(40),
  drive(.71, .41),                                
  wait(.1),
  turn(17),
  start(liftMacro(16)),
  drive(.7,.96),

  --===================================--

  start(tailSet(80)),                                  
  start(liftMacro(16)),
  start(inOut(1)),  
  turn(0),
  setIntake(-.6,.6),
  ----test vvv
  drive(.26, 1.2),
  wait(.32),
  -------
  setIntake(0, 0),                              
  -- has tote                                       
  start(liftMacro(0)),                                    
  turn(40),
  drive(.71, .41),                                
  wait(.1),
  turn(17),
  start(liftMacro(16)),
  drive(.7, .96),

  --==========================================--

  start(tailSet(80)),                                
  start(liftMacro(16)),
  start(inOut(1)),  
  turn(0),
  setIntake(-.6,.6),
  ----test vvv
  drive(.32, 1.2),
  wait(.32),
  -------
  setIntake(0, 0),                              
  -- has tote                                       
  start(liftMacro(12)),
  turn(110),
  start(liftMacro(8)),
  drive(1, 1),
  setIntake(1,-1),
  drive(1, .3),
  wait(.5),
  setIntake(0, 0)
  
  
)--]]










local core = require "core"
local angOffset
local ang

local alpha = 0.25
local emaVal = 0

local function updateEMA(val)
  emaVal = alpha * val + (1-alpha)*emaVal
  return emaVal
end

subscribe("Vision/Center", function(topic, payload)
    --local x, y = payload
    print("Tote is at " .. payload)
    local index = string.find(payload, ", ")
    local x = tonumber(string.sub(payload,1,index-1))
    local y = tonumber(string.sub(payload,index+2))

    angOffset = 90 - math.deg(math.atan2(480-y, x-320))
    if angOffset < 0 then angOffset = angOffset
    end
    print("angOffset: " .. angOffset)
    ang = updateEMA(robotMap.navX:GetYaw() + angOffset)
    print("ang: " .. ang)
  end
)

--===========================================================---
local spinTurn = function()





-----------------------------
  local pidLoop = require"core.PID"
  local PID = pidLoop(0.03,0,0.5)
-----------------------------
  local heading = 0
  local startTime = 0
  local lastTime = 0
  local turn = {
    Initialize = function()
      PID.minOutput = -1
      PID.maxOutput = 1
      PID.minInput = -180
      PID.maxInput = 180
      PID.continuous = true


      print("SpinTurn turning")
      heading = 0
      PID.setpoint = ang or robotMap.navX:GetYaw()
      print"starting timestamps"
      startTime =  WPILib.Timer.GetFPGATimestamp()
      lastTime = WPILib.Timer.GetFPGATimestamp()
      print"finished timestamps"
      print"finished calibration"
      --  Robot.drive:MecanumDrive_Cartesian(0, 0, -power)
    end,
    Execute = function()
      local angVal = 000
      if ang == nil then
        angVal = 000
      elseif ang ~= nil then
        angVal = ang
      end
      print("Setting pid target to " .. angVal .. "or " .. robotMap.navX:GetYaw())
      PID.setpoint = ang or robotMap.navX:GetYaw()
      heading = robotMap.navX:GetYaw()
      --print("Heading",heading)
      publish("Robot/Heading", heading)
      local response = PID:Update(heading)    
      Robot.drive:MecanumDrive_Cartesian(0, response, 0)
      lastTime = WPILib.Timer.GetFPGATimestamp()
    end,
    IsFinished = function() 
      return false
    end,
    End = function(self)

      Robot.drive:MecanumDrive_Cartesian(0, 0, 0)
    end,
    Interrupted = function(self)
      print("I have been interrrupted")
      self:End()
    end,
    subsystems = {
      "DriveTrain"
    }
  }
  return turn
end
return spinTurn()

