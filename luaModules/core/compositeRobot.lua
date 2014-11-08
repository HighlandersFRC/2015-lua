local auto = {
  Initialize = function()
      for k, op in pairs(Robot.private.autoList) do
        op:Initialize()
      end
  end,
  Execute = function()
    for k, op in pairs(Robot.private.autoList) do
	    op:Execute()
    end
  end,
  End = function()
    for k, op in pairs(Robot.private.autoList) do
	    op:End()
      end
  end,
  Put = function(name, act)
    if not (name and act) then return end
  Robot.private.autoList[name] = act
  end,
  Remove = function(name)
    if not name then return end
	Robot.private.autoList[name] = nil
  end
}

local teleop = {
  Initialize = function()
    print"composite teleop init"
    for k, op in pairs(Robot.private.teleopList) do
	    op:Initialize()
    end
  end,
  Execute = function()
    for k, op in pairs(Robot.private.teleopList) do
	    op:Execute()
    end
  end,
  End = function()
    for k, op in pairs(Robot.private.teleopList) do
	    op:End()
    end
  end,
  Put = function(name, act)
    if not (name and act) then return end
	Robot.private.teleopList[name] = act
  end,
  Remove = function(name)
    if not name then return end
	Robot.private.telopList[name] = nil
  end
}

local disabled = {
  Initialize = function()
    for k, op in pairs(Robot.private.disabledList) do
	    op:Initialize()
    end
  end,
  Execute = function()
    for k, op in pairs(Robot.private.disabledList) do
	    op:Execute()
    end
  end,
  End = function()
    for k, op in pairs(Robot.private.disabledList) do
	    op:End()
    end
  end,
  Put = function(name, act)
    if not (name and act) then return end
	Robot.private.disabledList[name] = act
  end,
  Remove = function(name)
    if not name then return end
	Robot.private.disabledList[name] = nil
  end
}

return function()
  Robot = {reset = resetBackup,
    Autonomous = auto,
    Teleop = teleop,
    Disabled = disabled,
    type = "composite",
    private = {autolist = {}, teleopList = {}, disabledList = {}}
  }
end