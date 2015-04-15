local core = require "core"
local scheduler = require "command.Scheduler"
local printCmd = require "command.Print"
local command = require "command"
local sequence = require "command.Sequence"
local start = require "command.Start"
debugPrint = function() end
core.setBasicRobot()
Robot.scheduler = scheduler()

Robot.scheduler:SetDefaultCommand("derp",printCmd("default command"))

Robot.Disabled = {
  Initialize = function()

  end,
  End = function()
  end,
  Execute = function()
    Robot.scheduler:Execute()
  end,
}

local testing = command{
  IsFinished = function() 
    return true
  end,
  subsystems = {
    "derp"
  }
}
local changeDefault = {
    Initialize = function(self)
      print("changing default")
      Robot.CurrentScheduler:SetDefaultCommand("derp", printCmd("no more derp"))
    end,
    IsFinished = function(self)
      return true
    end,
    Execute = function()

    end,
    subsystems = {
      
    },
    Interrupted = function()

    end,
    End = function(self)

    end
  }

local interrupt = function()
  local time = os.time()

  local interrupt = {
    Initialize = function(self)
      time = os.time()
      print("ran")
    end,
    IsFinished = function(self)
      --print(os.difftime(time, os.time()))
      return os.difftime(time, os.time()) < -2
    end,
    Execute = function()

    end,
    subsystems = {
      "derp"
    },
    Interrupted = function()

    end,
    End = function(self)

    end
  }
  return interrupt
end


local wait = function(waitTime)
  local time

  local waitTable = {
    Initialize = function(self)
      time = os.time()
    end,
    Execute = function()
    
    end,
    IsFinished = function(self)
      --print(os.difftime(time, os.time()))
      return os.difftime(time, os.time()) < -waitTime
    end,
    subsystems = {

    },
    Interrupted = function(self)

    end,
    End = function()

    end

  }
  return waitTable
end

local interrupts = sequence(
  start(interrupt()),
  wait(6),
  start(interrupt()),
  wait(1),
  changeDefault,
  start(interrupt())
)

Robot.scheduler:StartCommand(interrupts)
while true do
  Robot.scheduler:Execute()
end


