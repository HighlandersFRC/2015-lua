setCompositeRobot()

Robot.driveFL = getTalon(1)
Robot.driveBL = getTalon(2)
Robot.driveFR = getTalon(3)
Robot.driveBR = getTalon(4)
Robot.kickA = getTalon(5)
Robot.kickB = getTalon(6)
Robot.intakeWheel = getTalon(7)
Robot.platform = getTalon(8)

Robot.rightEnc = WPILib.Encoder(WPILib.asUint32(2), WPILib.asUint32(3))
Robot.leftEnc = WPILib.Encoder(WPILib.asUint32(4), WPILib.asUint32(5))

Robot.shiftH = getSolenoid(1)
Robot.shiftL = getSolenoid(2)
Robot.intakeArmIn = getSolenoid(3)
Robot.intakeArmOut = getSolenoid(4)

Robot.compressor = WPILib.Compressor(WPILib.asUint32(1), WPILib.asUint32(1))

Robot.Teleop.Put("checkRestart",
  {
    Execute = function()
      if getJoyBtn(1, 5):Get() then
        print"RESTARTING LUA CODE"
        Restart()
      end
    end
  }
)

dofile"/lua/Quasar/drive.lua"