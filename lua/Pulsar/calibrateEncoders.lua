
print("Calibration Started")
local calibration = function()
  local upDownDone = false;
  local inOutDone = false;
  
  local calibrate = {
    Initialize = function()
      --robotMap.lifterInOut:Set(.4)
      robotMap.lifterUpDown:Set(-.05)
      robotMap.lifterUpDownTwo:Set(-.05)
      
    end,
    Execute = function()
      if robotMap.lifterUpDown:IsRevLimitSwitchClosed() then
        robotMap.lifterUpDown:Set(0)
        robotMap.lifterUpDownTwo:Set(0)
        print("LifterUpDown hit botton limitswitch")  
        robotMap.lifterUpDown:SetPosition(0)
        upDownDone = true;
      end
      if robotMap.lifterInOut:IsRevLimitSwitchClosed() then
        robotMap.lifterInOut:Set(0)
        print("LifterInOut hit botton limitswitch")  
        robotMap.lifterInOut:SetPosition(0)
        inOutDone = true;
      end
    end,
    IsFinished = function() 

      return inOutDone and upDownDone
    end,
    End = function(self)
      print("Ending THE Calibration sequence here___________________")
      robotMap.lifterUpDown:Set(0)
      robotMap.lifterInOut:Set(0)
    end,
    Interrupted = function(self)
      print("I have been interrrupted")
      self:End()
    end,
    IsInterruptible = function()
      return false
    end,
    subsystems = {
      "lifterUpDown","lifterInOut"
    }
  }
  return calibrate
end
return calibration
