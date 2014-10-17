local restartBtn = WPILib.JoystickButton(getJoy(1), 1)

local controlBtns = {
  [WPILib.JoystickButton(getJoy(1), 3)] = "/lua/basicTank.lua",
  [WPILib.JoystickButton(getJoy(1), 2)] = "/lua/basicArcade.lua"
}

local action = {
  restartBtn = restartBtn,
  controlBtns = controlBtns
}

action.Initialize = function(self)
  print"SwitchFileControls Initialize."
end

action.Execute = function(self)
  for btn, name in pairs(self.controlBtns) do
    if btn:Get() then
      SetUserStartupName(name)
    end
  end
  if restartBtn:Get() then
    Restart()
  end
end

action.End = function(self)
  print"SwitchFileControls End"
end

return action