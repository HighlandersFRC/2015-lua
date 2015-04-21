local parallel = require "command.Parallel"
local chaseVision = require"Pulsar.Auto.ChaseVision"
local liftMacro = require "Pulsar.Auto.lifterUpDown"

robotMap.navX:ZeroYaw()

return parallel(chaseVision,liftMacro(18))