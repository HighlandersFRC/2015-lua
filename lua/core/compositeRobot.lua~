local resetBackup = Robot.reset

local auto = {
    Initialize = function()
        for op in Robot.private.autoList do
	    op:Initialize()
        end
    end,
    Execute = function()
        for op in Robot.private.autoList do
	    op:Execute()
        end
    end,
    End = function()
        for op in Robot.private.autoList do
	    op:End()
        end
    end,
    Put = function(name, act)
        if ~(name and act) then return end
	Robot.private.autoList[name] = act
    end,
    Remove = function(name)
        if ~name then return end
	Robot.private.autoList[name] = nil
    end
}

local teleop = {
    Initialize = function()
        for op in Robot.private.teleopList do
	    op:Initialize()
        end
    end,
    Execute = function()
        for op in Robot.private.teleopList do
	    op:Execute()
        end
    end,
    End = function()
        for op in Robot.private.teleopList do
	    op:End()
        end
    end,
    Put = function(name, act)
        if ~(name and act) then return end
	Robot.private.teleopList[name] = act
    end,
    Remove = function(name)
        if ~name then return end
	Robot.private.telopList[name] = nil
    end
}

local disabled = {
    Initialize = function()
        for op in Robot.private.disabledList do
	    op:Initialize()
        end
    end,
    Execute = function()
        for op in Robot.private.disabledList do
	    op:Execute()
        end
    end,
    End = function()
        for op in Robot.private.disabledList do
	    op:End()
        end
    end,
    Put = function(name, act)
        if ~(name and act) then return end
	Robot.private.disabledList[name] = act
    end,
    Remove = function(name)
        if ~name then return end
	Robot.private.disabledList[name] = nil
    end
}

Robot = {reset = resetBackup,
    Autonomous = auto,
    Teleop = teleop,
    Disabled = disabled,
    type = "composite",
    private = {autolist = {}, teleopList = {}, disabledList = {}}
}