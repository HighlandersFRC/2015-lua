local core = require "core"
local wait = function(trig, seconds)
  local waitTime = {
    Initialize = function()
      timer = WPILib.Timer()
      timer:Start()
    end,
    Execute = function()
    end,
    IsFinished = function()
      return trig:Get() or (seconds and timer:Get() >= seconds)
    end,
    subsystems = {
    },
    End = function()
    end,
    Interrupted = function(self)
      self:End()
    end
  }
  return waitTime
end
return wait