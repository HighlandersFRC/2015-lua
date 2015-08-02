local corocmd = require"command.CoroutineCommand"
print("Calibration Started")
local calibration = function()
  local calibrating = function()
    local count = 0
    while( not robotMap.lifterInOut:IsFwdLimitSwitchClosed()) do 
      robotMap.lifterInOut:Set(.5)
      if count % 50 == 0 then
        print("(lifterInOUtCalibration) lifter int out waiting for limit switch", robotMap.lifterInOut:IsFwdLimitSwitchClosed(), robotMap.lifterInOut:IsRevLimitSwitchClosed())
      end
      count = count + 1
      coroutine.yield()
    end

    robotMap.lifterInOut:Set(0)
    local position = robotMap.lifterInOut:GetPosition()
    while math.abs(robotMap.lifterInOut:GetPosition() - position) < 500 do
      if count % 50 == 0 then
        print("waiting for encoder", math.abs(robotMap.lifterInOut:GetPosition() - position))
      end
      count = count + 1
      robotMap.lifterInOut:Set(-.3)
      coroutine.yield()

    end
    while( not robotMap.lifterInOut:IsFwdLimitSwitchClosed()) do 
      robotMap.lifterInOut:Set(.2)
      coroutine.yield()
    end
    robotMap.lifterInOut:Set(0)
    robotMap.lifterInOut:SetPosition(0)
  end
  return corocmd(calibrating,{"LifterInOut"},nil,function() robotMap.lifterInOut:Set(0) end)
end
return calibration