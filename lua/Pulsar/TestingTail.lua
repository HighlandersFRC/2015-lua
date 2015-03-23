local core = require"core"
local lidar = require"ArduLidar"
local Scheduler = require"command.Scheduler"


core.setBasicRobot()
WPILib_backup = WPILib
core.setCompositeRobot()
Robot.scheduler = Scheduler()
Robot.schedulerAuto = Scheduler()
local power = .5
--sPDP = WPILib.PowerDistributionPanel()
local motor = core.getCanTalon(1)
local tailButtonOne = core.getJoyBtn(0,4)
local tailButtonTwo = core.getJoyBtn(0,2)
Robot.Teleop.Put("move",{
    Initialize = function()
      motor:Set(power)
    end,
    Execute = function()
      --print("adjustedVal:",motor:GetOutputCurrent()*1/power,"raw value:",motor:GetOutputCurrent())
      print(motor:GetOutputCurrent()*(motor:GetBusVoltage() / motor:GetOutputVoltage()))
    end,  
    End = function()
    end
  })
