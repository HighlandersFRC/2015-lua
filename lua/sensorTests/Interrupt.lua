local core = require "core"
local inter = function()
local time = os.time()
    
  local interrupt = {
    Initialize = function(self)
      time = os.time()
      print("ran")
    end,
    IsFinished = function(self)
      --print(os.difftime(time, os.time()))
      return os.difftime(time, os.time()) < -4
    end,
    Execute = function()
      
      end,
    subsystems = {
      "derp"
    },
    Interrupted = function()
      
      end,
    End = function(self)
      
    end
  }
  return interrupt
end

return inter