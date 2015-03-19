local function SetIntake(leftPwr, rightPwr)
  return {
    Initialize = function()
        robotMap.leftIntake:Set(leftPwr)
        robotMap.rightIntake:Set(rightPwr or -leftPwr)
    end,
    Execute = function() end,
    End = function() end,
    IsFinished = function() return true end,
    subsystems = {"intake"}
  }
end

return SetIntake