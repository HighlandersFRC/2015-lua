setCompositeRobot()

Robot.driveFL = getTalon(1)
Robot.driveBL = getTalon(2)
Robot.driveFR = getTalon(3)
Robot.driveBR = getTalon(4)

Robot.leftEnc = WPILib.Encoder(WPILib.asUint32(2), WPILib.asUint32(3))
Robot.rightEnc = WPILib.Encoder(WPILib.asUint32(4), WPILib.asUint32(5))

Robot.shiftL = getSolenoid(1)
Robot.shiftH = getSolenoid(2)

Robot.compressor = WPILib.Compressor(WPILib.asUint32(1), WPILib.asUint32(1))

dofile"/lua/driveTuneMain.lua"
