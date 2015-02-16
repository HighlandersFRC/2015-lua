local core = require "core"
--local pid = require "PID"

--local pidLoop = pid(0.1, 0.01, 0.005)
local intake = function()



  local intakeAuto = {
    Initialize = function(self)
      timer = WPILib.Timer()
      --newPid.setpoint = 2965
      --robotMap.lifterUpDown:SetFeedbackDevice(0)
      --for k,v in pairs(robotMap) do print(k,v) end

      robotMap.rightIntake:Set(-1)
      robotMap.leftIntake:Set(1)
      timer:Start()
      --robotMap.lifterInOut:Set(1)
      --robotMap.lifterInOut:Set(1)
      --robotMap.lifterUpDown:Set(1)
      --robotMap.lifterUpDownTwo:Set(1)
      --print(lifterUpDown:GetEncPosition()) -- returns number of ticks int

    end,
    IsFinished = function(self)
      return timer:Get() >= 1.5
    end,
    Execute = function()
      print(robotMap.lifterUpDown:GetEncPosition())
    end,
    subsystems = {
      "Rightintake",
      "Leftintake"
    },
    Interrupted = function(self)
      self:End()
    end,
    End = function(self)
      robotMap.rightIntake:Set(0)
      robotMap.leftIntake:Set(0)
    end
  }
  return intakeAuto
end

return intake