local core = require "core"
local angOffset
local ang
local inRange
local x
local y
local lidar = require"ArduLidar"
local alpha = 0.25
local emaVal = 0
local finished = false
local intakeCount = 0
local rightIntakeCurrent = 0
local leftIntakeCurrent = 0
local motorStallRatio = 3.33
local previousDistance = 0
local lidarLastTime = 0
local isStalled 
local function updateEMA(val)
  emaVal = alpha * val + (1-alpha)*emaVal
  return emaVal
end

subscribe("Vision/Center", function(topic, payload)
    --local x, y = payload
    --- print("Tote is at " .. payload)
    local index = string.find(payload, ", ")

    if payload == "" then
      print("(Chase Vision)Tote not found")
      ang = nil
      inRange = false
      return

    end
    x = tonumber(string.sub(payload,1,index-1)) - 170
    y = tonumber(string.sub(payload,index+2))


    --print("(ChaseVision)Targeting",x,y)

    --angOffset = 90 - math.deg(math.atan2(480-y, x-320))
    angOffset = (320-x)*45/320 
    if angOffset < 0 then angOffset = angOffset
    end
    if angOffset < 10 and angOffset > -10 then
      inRange = true
    else
      inRange = false
    end


    --- print("angOffset: " .. angOffset)
    ang = updateEMA(robotMap.navX:GetYaw() + angOffset)
    ---print("ang: " .. ang)
  end
)

--===========================================================---
local spinTurn = function()
-----------------------------
  local pidLoop = require"core.PID"
  local PID = pidLoop(0.03,0,0.02)
-----------------------------
  local heading = 0
  local startTime = 0
  local lastTime = 0

  local turn = {
    Initialize = function()
      finished = false
      PID.minOutput = -.6
      PID.maxOutput = .6
      PID.minInput = -180
      PID.maxInput = 180
      PID.continuous = true
      lidarLastTime =  WPILib.Timer.GetFPGATimestamp()
      previousDistance = lidar:Get()
      isStalled =false
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
        robotMap.leftIntake:Set(0)
        robotMap.rightIntake:Set(0)
        Robot.drive:MecanumDrive_Cartesian(0, 0, 0)
      elseif ang ~= nil then
        angVal = ang
      end
      -- print("Setting pid target to " .. angVal .. "or " .. robotMap.navX:GetYaw())
      PID.setpoint = ang or robotMap.navX:GetYaw()
      if PID.setpoint == robotMap.navX:GetYaw() then
        --print("(chase vision) the yaw has not changed")

      end
      heading = robotMap.navX:GetYaw()
      --print("Heading",heading)
      publish("Robot/Heading", heading)
      local response = PID:Update(heading)    
      lastTime = WPILib.Timer.GetFPGATimestamp()

      -- print("(ChaseVision)Lidar values",lidar:Get())

      if lidar:Get() ~=nil then

        if(lidar:Get() > 120) then
          robotMap.leftIntake:Set(-.5)
          robotMap.rightIntake:Set(.5)
          if inRange  then
            Robot.drive:MecanumDrive_Cartesian(0,response,-.3)
          else
            Robot.drive:MecanumDrive_Cartesian(0, response, 0)
          end
        elseif lidar:Get() > 65 then
          robotMap.leftIntake:Set(-1)
          robotMap.rightIntake:Set(1)
          Robot.drive:MecanumDrive_Cartesian(0, 0, -.22)
          intakeCount = 0
        elseif lidar:Get() > 40 then
          if not isStalled then
            robotMap.leftIntake:Set(-1)
            robotMap.rightIntake:Set(1)
            Robot.drive:MecanumDrive_Cartesian(0, 0, -.22)
            --print("[ChaseVision] intake in")
          end
          --print("[ChaseVIsion] delta distances",math.abs(lidar:Get() - previousDistance) /(WPILib.Timer.GetFPGATimestamp() - lastTime) )
          if math.abs(lidar:Get() - previousDistance) /(WPILib.Timer.GetFPGATimestamp() - lastTime)  < 40 then
            intakeCount = intakeCount+1
          else
            if(intakeCount) > 0 then
              intakeCount = intakeCount -1
            end
          end


          if intakeCount >=5 then
            --print("(ChaseVision) stall detected running out_______________________________________________________________")
            robotMap.leftIntake:Set(.5)
            robotMap.rightIntake:Set(-.5)
            Robot.drive:MecanumDrive_Cartesian(0, 0, 0)
            if(not isStalled) then
              intakeCount = 5
            end
            isStalled = true

          else
            isStalled = false

          end

        else
          robotMap.leftIntake:Set(0)
          robotMap.rightIntake:Set(0)local liftMacro = require "Pulsar.Auto.lifterUpDown"
local chaseTote = require "Pulsar.Auto.ChaseVision"
local sequence = require"command.Sequence"
          finished = true
        end
      end
      previousDistance = lidar:Get()
      lastTime = WPILib.Timer.GetFPGATimestamp()
    end,
    IsFinished = function() 
      return finished
    end,
    End = function(self)

      Robot.drive:MecanumDrive_Cartesian(0, 0, 0)
    end,
    Interrupted = function(self)
      print("I have been interrrupted")
      self:End()
    end,
    subsystems = {
      "DriveTrain","intake"
    }
  }
  return turn
end
return spinTurn()
