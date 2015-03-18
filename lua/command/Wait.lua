local core = require "core"
local wait = function(seconds)
  local waitTime = {
    Initialize = function()
      timer = WPILib.Timer()
      timer:Start()
    end,
    Execute = function()
    end,
    IsFinished = function()
      return timer:Get() >= seconds
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