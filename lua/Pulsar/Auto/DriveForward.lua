
print("drive forward auto started")
local driveForward = function(pwr, time)
  local gyro = require"Gyro"
  local core = require"core"
  local power = pwr * 12.5
  local delay = time
  local startTime = 0
  local lastTime = 0
  local heading = 0
  local startHeading = 0
-----------------------------
  local pidLoop = require"core.PID"
  local PID = pidLoop(0.1,.001,.01)
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
      PID.setPoint = startHeading
      robotMap.FLTalon:SetVoltageRampRate(0)
      robotMap.BLTalon:SetVoltageRampRate(0)
      robotMap.FRTalon:SetVoltageRampRate(0)
      robotMap.BRTalon:SetVoltageRampRate(0)
      
      robotMap.FLTalon:SetControlMode(CANSpeedController.kVoltage)
      robotMap.BLTalon:SetControlMode(CANSpeedController.kVoltage)
      robotMap.FRTalon:SetControlMode(CANSpeedController.kVoltage)
      robotMap.BRTalon:SetControlMode(CANSpeedController.kVoltage)
    end,
    Execute = function() 
      heading = robotMap.navX:GetYaw()
      lastTime = WPILib.Timer.GetFPGATimestamp()
      local response = PID:Update(heading)
      if count % 1 == 0 then
        
        print(heading, response )
        publish("Robot/Heading",heading..","..response)

      end
      count = count + 1
      -- update talon speeds gyro One
      Robot.drive:MecanumDrive_Cartesian(0,response , (-clamp(power,-WPILib.Timer.GetFPGATimestamp()) + startTime)*12.5, 12.5* (WPILib.Timer.GetFPGATimestamp() - startTime))
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
      
      
      robotMap.FLTalon:SetControlMode(CANSpeedController.kPercentVbus)
      robotMap.BLTalon:SetControlMode(CANSpeedController.kPercentVbus)
      robotMap.FRTalon:SetControlMode(CANSpeedController.kPercentVbus)
      robotMap.BRTalon:SetControlMode(CANSpeedController.kPercentVbus)
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
