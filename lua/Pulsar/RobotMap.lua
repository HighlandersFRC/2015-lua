print"in RobotMap"
local core = require"core"
--require"WPILib"
--print"required WPILib"
WPILib.Talon(1)
print"CANTalon"
local port = WPILib.SerialPort(57600,1)
robotMap = {
FLTalon = core.getCanTalon(1),
BLTalon = core.getCanTalon(2),
FRTalon = core.getCanTalon(3),
BRTalon = core.getCanTalon(4),
rightIntake = core.getCanTalon(5),
leftIntake = core.getCanTalon(6),
lifterUpDown = core.getCanTalon(7),
lifterUpDownTwo = core.getCanTalon(8),
lifterInOut = core.getCanTalon(9),
navXport = port,
  navX = WPILib.AHRS(port,50)
}

  