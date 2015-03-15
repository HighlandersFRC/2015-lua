--Intake PulsarStable

--debugPrint("intake started")
local core = require "core"
local power = .5
local delay = 1
local startTime = 0




local BLTest = {
  Initialize = function()
    print("Moving back left wheel")
     startTime = WPILib.Timer.GetFPGATimestamp()
    robotMap.BLTalon:Set(power)
    
  end,
  IsFinished = function() 
    return (startTime + delay <= WPILib.Timer.GetFPGATimestamp()) 
      
  end,
  End = function(self)
    
    robotMap.BLTalon:Set(0)
      print("Stopped back left wheel")

      Robot.scheduler:StartCommand(FLTest)
      robotMap.FLTalon:Set(power)
      
      
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "DriveTrain"
  }
}