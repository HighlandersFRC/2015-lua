local joystickPov = {}

local povDirs = {
  ["u"] = {0},
  ["r"] = {90},
  ["d"] = {180},
  ["l"] = {270},
  ["u*"] = {315, 0, 45},
  ["r*"] = {45, 90, 135},
  ["d*"] = {135, 180, 225},
  ["l*"] = {225, 270, 315},
  ["*"] = {0, 45, 90, 135, 225, 270, 315}
}

joystickPov.Get = function(self)
  local dir = self.joystick:GetPOV()
  for i=1, #povDirs[self.direction] do
    if dir == povDirs[self.direction][i] then
      return true
    end
  end
  return false
end

joystickPov.metatable = {
  __index = joystickPov,
  __call = function(pov) return pov:Get() end
}

joystickPov.newinstance = function(joystick, direction)
  local self = {
    joystick = joystick,
    direction = direction
  }
  setmetatable(self, joystickPov.metatable)
  return self
end

setmetatable(joystickPov, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return joystickPov