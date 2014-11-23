local core = require"core"

core.setCompositeRobot()

--restart button
local restartButton = core.getJoyBtn(1, 10)

-- motors
Robot.driveFL = core.getTalon(1)
Robot.driveBL = core.getTalon(2)
Robot.driveFR = core.getTalon(3)
Robot.driveBR = core.getTalon(4)
Robot.kickA = core.getTalon(5)
Robot.kickB = core.getTalon(6)
Robot.intakeWheel = core.getTalon(7)
Robot.platform = core.getTalon(8)

--encoders
Robot.rightEnc = WPILib.Encoder(WPILib.asUint32(2), WPILib.asUint32(3))
Robot.leftEnc = WPILib.Encoder(WPILib.asUint32(4), WPILib.asUint32(5))

--solenoids
Robot.shiftH = core.getSolenoid(1)
Robot.shiftL = core.getSolenoid(2)
Robot.intakeArmOut = core.getSolenoid(3)
Robot.intakeArmIn = core.getSolenoid(4)

--compressor
Robot.compressor = WPILib.Compressor(WPILib.asUint32(1), WPILib.asUint32(1))

--potentiometer
Robot.platformPot = WPILib.AnalogChannel(WPILib.asUint32(1))

Robot.Teleop.Put("checkRestart",
  {
    Execute = function()
      
      if restartButton:Get() then
        print"RESTARTING LUA CODE"
        Restart()
      end
    end
  }
)

dofile"/lua/Quasar/drive.lua"
dofile"/lua/Quasar/intake.lua"
dofile"/lua/Quasar/kicker.lua"
dofile"/lua/Quasar/platform.lua"