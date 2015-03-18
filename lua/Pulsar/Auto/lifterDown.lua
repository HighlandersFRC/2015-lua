local core = require "core"
local pidLoop = require "PID"            
local PID = pidLoop(0.16,0,0)
local lifterDown = function()

    
  local moveLifter = {
    Initialize = function(self)
      --local PID = pidLoop(0.16,0,0)
      timer = WPILib.Timer()
      robotMap.lifterUpDown:Set(-1)
      --robotMap.lifterUpDownTwo:Set(-1)
      timer:Start()
    end,
    IsFinished = function(self)
      return timer:Get() >= .8
    end,
    Execute = function()
      end,
    subsystems = {
      "intake"
    },
    Interrupted = function(self)
      self:End()
    end,
    End = function(self)

    end
  }
  return moveLifter
end

return lifterDown