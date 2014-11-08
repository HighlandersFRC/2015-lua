if SWITCHFILE_ENABLE then
  setCompositeRobot()

  Robot.Teleop.Put("switchfile", require("SwitchFileControls"))

  Robot.Teleop.Put("tank drive", dofile("/lua/basicTankTeleop.lua"))
else
  setBasicRobot()
  
  Robot.Teleop = dofile("/lua/basicTankTeleop.lua")
end
