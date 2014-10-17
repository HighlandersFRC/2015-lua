if SWITCHFILE_ENABLE then
  setCompositeRobot()

  Robot.Teleop.Put("switchfile", require("SwitchFileControls"))

  Robot.Teleop.Put("arcade drive", dofile("/lua/basicArcadeTeleop.lua"))
else
  setBasicRobot()
  
  Robot.Teleop = dofile("/lua/basicArcadeTeleop.lua")
end
