local core = require"core"

OI = {
intakeRightOut = core.getJoyBtn(0, 8),
intakeRightIn = core.getJoyBtn(0, 6),
intakeLeftOut = core.getJoyBtn(0, 7),
intakeLeftIn = core.getJoyBtn(0, 5),
DriveTheta = core.getJoyAxis(0,1),
DriveY = core.getJoyAxis(0,0),
DriveX = core.getJoyAxis(0,2),
lifterUpDown = core.getJoyAxis(1,3),   
lifterInOut = core.getJoyAxis(1,1),
driveSpeed = core.getJoyBtn(0,11),
driveSpeedTwo = core.getJoyBtn(0,12),
driveSlowSpeed = core.getJoyBtn(0,3),
zeroPreset = core.getJoyBtn(1,2),
outPreset = core.getJoyBtn(1,3),
inPreset = core.getJoyBtn(1,1),
topPreset = core.getJoyBtn(1,4),
calibrate = core.getJoyBtn(1,8),
canUp = core.getJoyBtn(1,6),
toteUp = core.getJoyBtn(1,5),
tail = core.getJoy(1)
}