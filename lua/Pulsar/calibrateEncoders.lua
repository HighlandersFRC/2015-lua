local corocmd = require"command.CoroutineCommand"
print("Calibration Started")
local calibration = function()
  local calibrating = function()
    local count = 0
    while( not robotMap.lifterUpDown:IsRevLimitSwitchClosed()) do 
      robotMap.lifterUpDown:Set(-.1)
      if count % 50 == 0 then
        print("waiting for limit switch", robotMap.lifterUpDown:IsFwdLimitSwitchClosed(), robotMap.lifterUpDown:IsRevLimitSwitchClosed())
      end
      count = count + 1
      coroutine.yield()
    end

    robotMap.lifterUpDown:Set(0)
    local position = -1*robotMap.lifterUpDown:GetPosition()
    while math.abs(-1*robotMap.lifterUpDown:GetPosition() - position) < 500 do
      if count % 50 == 0 then
        print("waiting for encoder", math.abs(-1*robotMap.lifterUpDown:GetPosition() - position))
      end
      count = count + 1
      robotMap.lifterUpDown:Set(.2)
      coroutine.yield()

    end
    while( not robotMap.lifterUpDown:IsRevLimitSwitchClosed()) do 
      robotMap.lifterUpDown:Set(-.05)
      coroutine.yield()
    end
    robotMap.lifterUpDown:Set(0)
    robotMap.lifterUpDown:SetPosition(0)
  end
  return corocmd(calibrating,{"LifterUpDown"},nil,function() robotMap.lifterUpDown:Set(0) end)
end
return calibration