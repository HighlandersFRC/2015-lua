local core = require "core"
local start = function(toStart)
  local startFile = {
    Initialize = function(self)
      Robot.CurrentScheduler:StartCommand(toStart)
    end,
    IsFinished = function(self)
      return true
    end,
    Execute = function()
      end,
    subsystems = {
      
    },
    Interrupted = function(self)
      self:End()
    end,
    End = function(self)
      
    end
  }
  return startFile
end

return start