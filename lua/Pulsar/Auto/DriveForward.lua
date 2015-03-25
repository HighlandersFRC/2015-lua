
print("drive forward auto started")
local driveForward = function(pwr, time)
  local gyro = require"Gyro"
  local core = require"core"
  local pwrMultiple = 1
  local power = pwr * pwrMultiple
  local accel = 2
  local delay = time
  local startTime = 0
  local lastTime = 0
  local heading = 0
  local startHeading = 0
-----------------------------
  local pidLoop = require"core.PID"
  local PID = pidLoop(0.02,.001,.05)
  PID.minInput = -180
  PID.maxInput = 180
  PID.continuous = true
-----------------------------
  local count = 0
  local clamp = function(val, clampValNeg,clampValPos)

    if val >= clampValPos then
      val = clampValPos
    end

    if val <= clampValNeg then
      val = clampValNeg
    end

    return val
  end
  local goForward = {
    Initialize = function()
      print("initializing")
      startTime = 0
      count = 0
      heading = 0
      lastTime = WPILib.Timer.GetFPGATimestamp()
      startTime = WPILib.Timer.GetFPGATimestamp()
      startHeading = robotMap.navX:GetYaw()
      --PID.setPoint = startHeading
      robotMap.FLTalon:SetVoltageRampRate(0)
      robotMap.BLTalon:SetVoltageRampRate(0)
      robotMap.FRTalon:SetVoltageRampRate(0)
      robotMap.BRTalon:SetVoltageRampRate(0)

      robotMap.FLTalon:SetControlMode(0)
      robotMap.BLTalon:SetControlMode(0)
      robotMap.FRTalon:SetControlMode(0)
      robotMap.BRTalon:SetControlMode(0)
      print("ControlMode",robotMap.FLTalon:GetControlMode() )
      print(power)

    end,
    Execute = function() 
      heading = robotMap.navX:GetYaw() - startHeading
      lastTime = WPILib.Timer.GetFPGATimestamp()
      local response = PID:Update(heading)
      if count % 1 == 0 then

        --print(heading, response )
        publish("Robot/Heading",heading..","..response)
        print(robotMap.PDP:GetVoltage())
      end
      count = count + 1
      -- update talon speeds gyro One
      Robot.drive:MecanumDrive_Cartesian(0,response , -clamp(power * 12/robotMap.PDP:GetVoltage(),(-WPILib.Timer.GetFPGATimestamp() + startTime)*pwrMultiple * accel , pwrMultiple * accel * (WPILib.Timer.GetFPGATimestamp() - startTime)))
    end,
    IsFinished = function() 
      return (startTime + delay <= WPILib.Timer.GetFPGATimestamp()) 
    end,
    End = function(self)
      Robot.drive:MecanumDrive_Cartesian(0, 0,0)
      robotMap.FLTalon:SetVoltageRampRate(0)
      robotMap.BLTalon:SetVoltageRampRate(0)
      robotMap.FRTalon:SetVoltageRampRate(0)
      robotMap.BRTalon:SetVoltageRampRate(0)


      robotMap.FLTalon:SetControlMode(0)
      robotMap.BLTalon:SetControlMode(0)
      robotMap.FRTalon:SetControlMode(0)
      robotMap.BRTalon:SetControlMode(0)
    end,
    Interrupted = function(self)
      self:End()
    end,
    subsystems = {
      "DriveTrain"
    }
  }
  return goForward
end
--Robot.scheduler:SetDefaultCommand("intakeWheels",intakeWheelsStopCommand)
--Robot.Teleop.Put("intakeWheels", intakeWheelsStopCommand)
--debugPrint("running go forward autonomous")


return driveForward
