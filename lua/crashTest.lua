local function stackOverflow()
  return stackOverflow() + 1
end

local crashBtns = {
  [WPILib.JoystickButton(getJoy(3), 1)] = function()
    (nil)()
  end,
  [WPILib.JoystickButton(getJoy(3), 2)] = stackOverflow,
  [WPILib.JoystickButton(getJoy(3), 3)] = function()
    getTalon(11)
  end,
  [WPILib.JoystickButton(getJoy(3), 4)] = function()
    divZero = 1/0
  end,
  [WPILib.JoystickButton(getJoy(3), 5)] = function()
    local Powerlevel = 9001
    assert(Powerlevel < 9000, "There is no way that could be right.")
  end,
  [WPILib.JoystickButton(getJoy(3), 6)] = function()
    error("Can Haz Cheezburger")
  end,
  [WPILib.JoystickButton(getJoy(3), 7)] = function()
    math.sqrt(-1)
  end,
  [WPILib.JoystickButton(getJoy(3), 8)] = function()
    load("invalidSyntax)blahblahblah")
  end,
  [WPILib.JoystickButton(getJoy(3), 9)] = function()
    (nil).sudo()
  end,
  [WPILib.JoystickButton(getJoy(3), 10)] = function()
    load("print(\"tada)")
  end,
  [WPILib.JoystickButton(getJoy(3), 11)] = function()
    load("\"blah\" + \"blah\"")
  end,
  [WPILib.JoystickButton(getJoy(4), 1)] = function()
    mountainDew()
  end
}


local action = {
  crashBtns = crashBtns
}

action.Initialize = function(self)
  print"Crash Test Initialize."
end

action.Execute = function(self)
  for btn, func in pairs(self.crashBtns) do
    if btn:Get() then
      func()
    end
  end
end

action.End = function(self)
  print"Crash Test End"
end

return action