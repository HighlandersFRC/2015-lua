local joystickButton = {}

joystickButton.Get = function(self)
  return self.joystick:GetRawButton(self.button)
end

joystickButton.metatable = {
  __index = joystickButton,
  __call = function(btn) return btn:Get() end
}

joystickButton.newinstance = function(joy, btnNum)
  local newBtn = {
    joystick = joy,
    button = btnNum
  }
  setmetatable(newBtn, joystickButton.metatable)
  return newBtn
end

setmetatable(joystickButton, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return joystickButton