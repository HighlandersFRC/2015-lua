local auto = {
  Initialize = function()
      for k, op in pairs(Robot.private.autoList) do
        if op.Initialize then
          op:Initialize()
        end
      end
  end,
  Execute = function()
    for k, op in pairs(Robot.private.autoList) do
      if op.Execute then
        op:Execute()
      end
    end
  end,
  End = function()
    for k, op in pairs(Robot.private.autoList) do
      if op.End then
        op:End()
      end
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
      if op.Initialize then
        op:Initialize()
      end
    end
  end,
  Execute = function()
    for k, op in pairs(Robot.private.teleopList) do
      if op.Execute then
        op:Execute()
      end
    end
  end,
  End = function()
    for k, op in pairs(Robot.private.teleopList) do
      if op.End then
        op:End()
      end
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
      if op.Initialize then
        op:Initialize()
      end
    end
  end,
  Execute = function()
    for k, op in pairs(Robot.private.disabledList) do
      if op.Execute then
        op:Execute()
      end
    end
  end,
  End = function()
    for k, op in pairs(Robot.private.disabledList) do
      if op.End then
        op:End()
      end
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