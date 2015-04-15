local core = require "core"
local ang
subscribe("Vision/Center", function(topic, payload)
    --local x, y = payload
    local index = string.find(payload, ", ")
    local x = tonumber(string.sub(1,index))
    local y = tonumber(string.sub(index+2)
    print("Tote is at " .. payload)
    ang = math.deg(math.atan2(480-y, 320-x))
    if ang < 0 then ang = ang + 360
  end
)

--===========================================================---
local spinTurn = function()
  
-----------------------------
  local pidLoop = require"core.PID"
  local PID = pidLoop(0.1,0.02,0.05)
-----------------------------
  local heading = 0
  local startTime = 0
  local lastTime = 0
  local turn = {
    Initialize = function()
      PID.minOutput = -.5
      PID.maxOutput = .5
      PID.minInput = -180
      PID.maxInput = 180
      PID.continuous = true
      
      
      print("SpinTurn turning")
      heading = 0
      PID.setpoint = ang
      print"starting timestamps"
      startTime =  WPILib.Timer.GetFPGATimestamp()
      lastTime = WPILib.Timer.GetFPGATimestamp()
      print"finished timestamps"
      print"finished calibration"
      --  Robot.drive:MecanumDrive_Cartesian(0, 0, -power)
    end,
    Execute = function()
       heading = robotMap.navX:GetYaw()
      print("Heading",heading)
      publish("Robot/Heading", heading)
      local response = PID:Update(heading)    
      Robot.drive:MecanumDrive_Cartesian(0, response, 0)
      lastTime = WPILib.Timer.GetFPGATimestamp()
    end,
    IsFinished = function() 
      return false
    end,
    End = function(self)
      
      Robot.drive:MecanumDrive_Cartesian(0, 0,0)
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



