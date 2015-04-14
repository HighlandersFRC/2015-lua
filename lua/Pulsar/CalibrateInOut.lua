local corocmd = require"command.CoroutineCommand"
print("Calibration Started")
local calibration = function()
  local calibrating = function()
    local count = 0
    while( not robotMap.lifterInOut:IsRevLimitSwitchClosed()) do 
      robotMap.lifterInOut:Set(-.1)
      if count % 50 == 0 then
        print("waiting for limit switch", robotMap.lifterInOut:IsFwdLimitSwitchClosed(), robotMap.lifterInOut:IsRevLimitSwitchClosed())
      end
      count = count + 1
      coroutine.yield()
    end

    robotMap.lifterInOut:Set(0)
    local position = -1*robotMap.lifterInOut:GetPosition()
    while math.abs(-1*robotMap.lifterInOut:GetPosition() - position) < 500 do
      if count % 50 == 0 then
        print("waiting for encoder", math.abs(-1*robotMap.lifterInOut:GetPosition() - position))
      end
      count = count + 1
      robotMap.lifterInOut:Set(.3)
      coroutine.yield()

    end
    while( not robotMap.lifterInOut:IsRevLimitSwitchClosed()) do 
      robotMap.lifterInOut:Set(-.05)
      coroutine.yield()
    end
    robotMap.lifterInOut:Set(0)
    robotMap.lifterInOut:SetPosition(0)
  end
  return corocmd(calibrating,{"LifterInOut"},nil,function() robotMap.lifterInOut:Set(0) end)
end
return calibration