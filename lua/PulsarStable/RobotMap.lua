print"in RobotMap"
local core = require"core"
--require"WPILib"
--print"required WPILib"
WPILib.Talon(1)
print"CANTalon"

robotMap = {
FLTalon = core.getCanTalon(1),
BLTalon = core.getCanTalon(2),
FRTalon = core.getCanTalon(3),
BRTalon = core.getCanTalon(4),
rightIntake = core.getCanTalon(5),
leftIntake = core.getCanTalon(6),
lifterUpDown = core.getCanTalon(7),
lifterupDownTwo = core.getCanTalon(8),
lifterInOut = core.getCanTalon(9)
}

  