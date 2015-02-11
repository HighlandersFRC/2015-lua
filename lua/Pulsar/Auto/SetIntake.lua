local function SetIntake(pwr)
  return {
    Initialize = function()
      robotMap.leftIntake:Set(pwr)
      robotMap.rightIntake:Set(pwr)
    end,
    Execute = function() end,
    End = function() end,
    IsFinished = function() return true end,
    subsys = {"intake"}
  }
end

return SetIntake