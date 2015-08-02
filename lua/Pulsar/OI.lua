local core = require"core"
local And = require"dataflow.And"
local Not = require"dataflow.Not"
local axis = core.getJoyAxis
local btn = core.getJoyBtn
local pov = core.getJoyPov

local gunnerAlt = btn(1, 7)

OI = {
intakeRightOut = core.getJoyBtn(0, 8),
intakeRightIn = core.getJoyBtn(0, 6),
intakeLeftOut = core.getJoyBtn(0, 7),
intakeLeftIn = core.getJoyBtn(0, 5),
DriveTheta = core.getJoyAxis(0,1),
DriveY = core.getJoyAxis(0,0),
DriveX = core.getJoyAxis(0,2),
driveSpeed = core.getJoyBtn(0,11),
driveSpeedTwo = core.getJoyBtn(0,12),
driveSlowSpeed = core.getJoyBtn(0,3),
--[[old gunner controls
lifterUpDown = core.getJoyAxis(1,3),   
lifterInOut = core.getJoyAxis(1,1),
lifterBottomPreset = core.getJoyBtn(1,2),
outPreset = core.getJoyBtn(1,3),
inPreset = core.getJoyBtn(1,1),
lifterTopPreset = core.getJoyBtn(1,4),
calibrate = core.getJoyBtn(1,10),
canUp = core.getJoyBtn(1,5),
toteUp = core.getJoyBtn(1,6),
tail = core.getJoy(1),
--liftCal = core.getJoyBtn(1,10),
tailPresetOne = core.getJoyBtn(1,8),
tailPresetTwo = core.getJoyBtn(1,7),
inOutDisable = core.getJoyBtn(2,6),
tailStow = core.getJoyBtn(1, 9)]]
--gunner controls
lifterUpDown = axis(1, 3),
lifterInOut = axis(1, 0),
tailUpDown = axis(1, 1),
lifterTopPreset = btn(1, 4),
lifterBottomPreset = btn(1, 2),
lifterInPreset = btn(1, 1),
lifterOutPreset = btn(1, 3),
lifterLandfillTotePreset = And(btn(1, 6), Not(gunnerAlt)),
lifterHumanFeedTotePreset = And(btn(1, 6), gunnerAlt),
lifterCanPreset = btn(1, 6),
lifterLandfillToteSeq = And(btn(1, 8), Not(gunnerAlt)),
lifterHumanFeedToteSeq = And(btn(1, 8), gunnerAlt),
lifterCalibrate = btn(1, 12),
tailProngsUp = pov(1, "l*"),
tailProngsDown = pov(1, "r*"),
tailHigh = pov(1, "u*"),
tailDown = pov(1, "d*"),
tailCarry = btn(1, 9),
tailStow = btn(1, 10),
tailCalibrate = btn(1, 11),


lifterInOutDisable = core.getJoyBtn(2,6),
lifterUpDownDisable = core.getJoyBtn(2,7)
}