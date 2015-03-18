local corocmd = require"command.CoroutineCommand"
print("Calibration Started")
local calibration = function()
  local calibrating = function()
    while( not robotMap.lifterUpDown:IsFwdLimitSwitchClosed()) do 
      robotMap.lifterUpDown:Set(-.1)
      coroutine.yield()
    end

    robotMap.lifterUpDown:Set(0)
    local position = -1*robotMap.lifterUpDown:GetPosition()
    while math.abs(-1*robotMap.lifterUpDown:GetPosition() - position) < 500 do 
      robotMap.lifterUpDown:Set(.1)
      coroutine.yield()

    end
    while( not robotMap.lifterUpDown:IsFwdLimitSwitchClosed()) do 
      robotMap.lifterUpDown:Set(-.05)
      coroutine.yield()
    end
    robotMap.lifterUpDown:Set(0)
    robotMap.lifterUpDown:SetPosition(0)
  end
  return corocmd(calibrating,{"LifterUpDown"},nil,function() robotMap.lifterUpDown:Set(0) end)
end
return calibration