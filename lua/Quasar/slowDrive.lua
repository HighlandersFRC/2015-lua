local core = require"core"

local shiftButton = core.getJoyBtn(1, 6)

local drive = {
	Execute = function() 
		local leftpwr = f(core.getJoy(1):GetY())/2
		local rightpwr = f(-core.getJoy(1):GetRawAxis(WPILib.asUint32(4)))/2
		Robot.driveFL:Set(leftpwr)
		Robot.driveBL:Set(leftpwr)
		Robot.driveFR:Set(rightpwr)
		Robot.driveBR:Set(rightpwr)
	end,
	End = function()
		Robot.driveFL:Set(0)
		Robot.driveBL:Set(0)
		Robot.driveFR:Set(0)
		Robot.driveBR:Set(0)
	end
}

local shift = {
	Execute = function()
		local shift = shiftButton:Get()
		Robot.shiftL:Set(shift)
		Robot.shiftH:Set(not shift)
	end
}

local compress = {
	Initialize = function()
		Robot.compressor:Start()
	end,
	Execute = function() end
}

local leftMax = 0
local rightMax = 0

Robot.leftEnc:SetDistancePerPulse(6*math.pi/1440/12 * 22/19)
Robot.rightEnc:SetDistancePerPulse(6*math.pi/1440/12)

local encRead = {
	Execute = function()
		if dbgprnt then
			leftMax = Robot.leftEnc:GetRate()
			rightMax = Robot.rightEnc:GetRate()
			print("encoder rates:", "left:", leftMax, "right:", rightMax)
		end
	end
}

function sgn(x)
	if x>0 then
		return 1
	elseif x<0 then
		return -1
	else
		return 0
	end
end

function iffn(cond, a, b)
	if cond then
		return a
	else
		return b
	end
end

driveFuncs = {
	linear = function(x)
		return x
	end,
	quad = function(x)
		return sgn(x)*x*x
	end,
	cube = function(x)
		return x*x*x
	end,
	sqrt = function(x)
		return sgn(x)*math.sqrt(math.abs(x))
	end,
	cbrt = function(x)
		return sgn(x)*math.cbrt(math.abs(x))
	end,
	fifthrt = function(x)
		return sgn(x)*(math.abs(x)^(1/5))
	end,
	sin = function(x)
		return math.sin(x*math.pi/2)
	end
}

if not _G["f"] then
	f = driveFuncs.linear
end

Robot.Teleop.Put("drive", drive)
Robot.Teleop.Put("shift", shift)
Robot.Teleop.Put("compress", compress)
Robot.Teleop.Put("encode", encRead)

Robot.leftEnc:Start()
Robot.rightEnc:Start()
