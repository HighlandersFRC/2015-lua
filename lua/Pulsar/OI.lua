local core = require"core"

OI = {
intakeRightOutBtn = core.getJoyBtn(0, 8),
intakeRightInBtn = core.getJoyBtn(0, 6),
intakeLeftOutBtn = core.getJoyBtn(0, 7),
intakeLeftInBtn = core.getJoyBtn(0, 5),
DriveTheta = core.getJoyAxis(0,1),
DriveY = core.getJoyAxis(0,2),
DriveX = core.getJoyAxis(0,0),
lifterUp = core.getJoyBtn(0,4),   
lifterDown = core.getJoyBtn(0,2),
lifterIn = core.getJoyBtn(0,1),
lifterOut = core.getJoyBtn(0,3)
}

