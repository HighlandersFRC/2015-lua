local function SetIntake(pwr, left)
  return {
    Initialize = function()
      if left then
        robotMap.leftIntake:Set(pwr)
        robotMap.rightIntake:Set(pwr)
      else
      robotMap.leftIntake:Set(pwr)
      robotMap.rightIntake:Set(-pwr)
    end,
    Execute = function() end,
    End = function() end,
    IsFinished = function() return true end,
    subsystems = {"intake"}
  }
end

return SetIntake