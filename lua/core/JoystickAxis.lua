local joystickAxis = {}

joystickAxis.Get = function(self)
  return self.joystick:GetRawAxis(self.axis)
end

joystickAxis.metatable = {
  __index = joystickAxis,
  __call = function(axis) return axis:Get() end
}

joystickAxis.newinstance = function(joy, axisNum)
  local newAxis = {
    joystick = joy,
    axis = axisNum
  }
  setmetatable(newAxis, joystickAxis.metatable)
  return newAxis
end

setmetatable(joystickAxis, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return joystickAxis