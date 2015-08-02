return {
  Initialize = function() end,
  Execute = function()
    robotMap.lifterUpDown:Set(0)
    end,
  End = function() end,
  IsFinished = function() return false end,
  Interrupted = function() end,
  subsystems = {"lifterUpDown"}
}
