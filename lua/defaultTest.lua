local core = require "core"
local scheduler = require "command.Scheduler"
local printCmd = require "command.Print"
local command = require "command"
core.setBasicRobot()
Robot.scheduler = scheduler()

Robot.scheduler:SetDefaultCommand("derp",printCmd("a;df"))


local testing = command{
  IsFinished = function() 
    return true
  end,
  subsystems = {
    "derp"
  }
}

robot.scheduler:StartCommand(testing)


