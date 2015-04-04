print"in RobotMap"
local core = require"core"
--require"WPILib"
--print"required WPILib"
local port = WPILib.SerialPort(57600,1)


robotMap = {
FLTalon = core.getCanTalon(1),
  BLTalon = core.getCanTalon(2),
  FRTalon = core.getCanTalon(3),
  BRTalon = core.getCanTalon(4),
  rightIntake = core.getCanTalon(5),
  leftIntake = core.getCanTalon(6),
  lifterUpDown = core.getCanTalon(7),
  lifterInOut = core.getCanTalon(9),
  --navXport = port,
  navX = WPILib.AHRS(port,50),
  tail = core.getCanTalon(11),
  tailProngs = core.getCanTalon(10),
  PDP = WPILib.PowerDistributionPanel()
}
local lifterUpDownTwo = core.getCanTalon(8)
lifterUpDownTwo:SetControlMode(WPILib.CANTalon.kFollower)
lifterUpDownTwo:Set(7)
robotMap.lifterUpDownTwo = lifterUpDownTwo

