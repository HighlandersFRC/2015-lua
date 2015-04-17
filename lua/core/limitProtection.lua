
print("zeroEncoders Started")
local zeroEncoder = {
  Initialize = function()
    print("calibrateEncodersStarted")
  end,
  Execute = function()
    --[[
    print(robotMap.lifterUpDown:GetEncPosition()/1000 /25.4 * 120)
    print("upDown encoder",robotMap.lifterUpDown:IsRevLimitSwitchClosed())
    print("inOut encoder", robotMap.lifterInOut:IsRevLimitSwitchClosed())
    if robotMap.lifterUpDown:IsFwdLimitSwitchClosed() then
      robotMap.lifterUpDown:Set(0)
      -- robotMap.lifterUpDownTwo:Set(0)
      print("LifterUpDown hit botton limitswitch")  
      robotMap.lifterUpDown:SetPosition(0)
    end

    if robotMap.lifterInOut:IsFwdLimitSwitchClosed() then
      robotMap.lifterInOut:Set(0)
      print("LifterInOut hit inner limitswitch")  
      robotMap.lifterInOut:SetPosition(0)
    end]]
  end,
  IsFinished = function() 

  end,
  End = function(self)
  end,
  Interrupted = function(self)
    print("I have been interrrupted")
    self:End()
  end,
  subsystems = {
  }
}
Robot.scheduler:StartCommand(zeroEncoder)
