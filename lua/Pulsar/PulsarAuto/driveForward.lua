--Intake Pulsar
print("drive forward auto started")
local gyro = require"Gyro"
local core = require"core"
local power = .1
local delay = 10
local startTime = 0
local lastTime = 0
local heading = 0
-----------------------------
local pidLoop = require"core.PID"
local PID = pidLoop(0.175,0,0)
-----------------------------
local count = 0
-------------------------

-- Intake In Command

local goForward = {
  Initialize = function()
    heading = 0
    lastTime = WPILib.Timer.GetFPGATimestamp()
    print("I am starting goForward Command")
    gyro.Calibrate(100,.01)
    startTime = WPILib.Timer.GetFPGATimestamp()
    print("Heading == " .. heading )
    Robot.drive:MecanumDrive_Cartesian(0, 0, -power)
  end,
  Execute = function()

    local x,y,z = gyro.Get()
    prin("x = " ..x)
    local deltaTime = WPILib.Timer.GetFPGATimestamp() - lastTime
    local X = x * (deltaTime) 
    heading = heading + X
    lastTime = WPILib.Timer.GetFPGATimestamp()
    local response = PID:Update(heading)
    if count % 50 == 0 then
      print(x .."    " .."       "..y.."        "..z)
      print("Heading == " .. heading )
      print("response   " .. response)

    end
    count = count + 1
    -- update talon speedsgyroOne
    Robot.drive:MecanumDrive_Cartesian(0, response, -power)

  end,
  IsFinished = function() 
    return false--(startTime + delay <= WPILib.Timer.GetFPGATimestamp()) 

  end,
  End = function(self)

    Robot.drive:MecanumDrive_Cartesian(0, 0,0)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "DriveTrain"
  }
}
--Robot.scheduler:SetDefaultCommand("intakeWheels",intakeWheelsStopCommand)
--Robot.Teleop.Put("intakeWheels", intakeWheelsStopCommand)
debugPrint("running go forward autonomous")


return goForward

