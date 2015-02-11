local core = require "core"
local arc = function(degree, speed, radius)
   --                   circumference vvvv              
    local first = (6.28318 * (radius - 13.4375)) / (360 / degree)
    print("first is " .. first)
    local second = (6.28318 * (radius + 13.4375)) / (360 / degree)
    print("second is " .. second)
    
    local firstRatio = (first / second) / 1.1
    print("firstRatio is " .. firstRatio)
    local secondRatio = (second / second) / 1.1
    print("secondRatio is " .. secondRatio)
    while secondRatio > 1 do
      print("went into the while thing")
      secondRatio = secondRatio / 2
      firstRatio = firstRatio / 2
    end
    
  local arcDrive = {
    Initialize = function(self)
      timer = WPILib.Timer()
    if degree > 0 then
      robotMap.FRTalon:Set(-firstRatio)
      robotMap.FLTalon:Set(secondRatio)
      robotMap.BRTalon:Set(-firstRatio)
      robotMap.BLTalon:Set(secondRatio)
    end
    if degree < 0 then
      robotMap.FRTalon:Set(firstRatio)
      robotMap.FLTalon:Set(-secondRatio)
      robotMap.BRTalon:Set(firstRatio)
      robotMap.BLTalon:Set(-secondRatio)
    end
      timer:Start()
    end,
    IsFinished = function(self)
      return timer:Get() >= .25
    end,
    Execute = function()
      end,
    subsystems = {
      "drive"
    },
    Interrupted = function(self)
      self:End()
    end,
    End = function(self)
      robotMap.FRTalon:Set(0)
      robotMap.FLTalon:Set(0)
      robotMap.BRTalon:Set(0)
      robotMap.BLTalon:Set(0)
    end
  }
  return arcDrive
end

return arc