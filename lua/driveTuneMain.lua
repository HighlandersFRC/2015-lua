if not _G["kP"] then
	kP = 1
	kI = 0
	kD = 0
end
if not _G["maxSpeed"] then
	maxSpeed = 10
end
if not _G["maxAccel"] then
	maxAccel = 5
end

local leftPID = {
	setpoint = 0,
	accum = 0,
	last = 0
}

local rightPID = {
	setpoint = 0,
	accum = 0,
	last = 0
}

local function PIDupdate(pid, val)
	local outval = 0
	outval = outval + kP * (pid.setpoint - val)
	pid.accum = pid.accum + (pid.setpoint - val) * 0.05
	outval = outval + kI * pid.accum
	outval = outval + kD * (pid.last - val + pid.setpoint) * 20
	pid.last = val
	return outval
end

local drive = {
	Execute = function() 
		local left = f(getJoy(1):GetY())
		local right = f(-getJoy(1):GetRawAxis(WPILib.asUint32(4)))
		if math.abs(left-leftPID.setpoint) > maxAccel/maxSpeed then
			if left > leftPID.setpoint then
				leftPID.setpoint = leftPID.setpoint + maxAccel/maxSpeed/20
			else
				if left < leftPID.setpoint then
					leftPID.setpoint = leftPID.setpoint - maxAccel/maxSpeed/20
				end
			end
		else
			leftPID.setpoint = left
		end
		if math.abs(right-rightPID.setpoint) > maxAccel/maxSpeed then
			if right > rightPID.setpoint then
				rightPID.setpoint = rightPID.setpoint + maxAccel/maxSpeed/20
			else
				if right < rightPID.setpoint then
					rightPID.setpoint = rightPID.setpoint - maxAccel/maxSpeed/20
				end
			end
		else
			rightPID.setpoint = right
		end
		local leftpwr = PIDupdate(leftPID, Robot.leftEnc:GetRate()/maxSpeed)
		local rightpwr = PIDupdate(rightPID, Robot.rightEnc:GetRate()/maxSpeed)
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
		local shift = getJoyBtn(2, 2):Get()
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
