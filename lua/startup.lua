-- This code is for custom robot initialization.
-- It is automatically run on boot.
-- It can safely be modified to load robot programs.
-- Setting up the hardware and control mapping belongs elsewhere.

print("beginning lua user initialization")

--require("mqtt_lua_console").start()

dofile("/lua/basicTank.lua")

Robot.Teleop.Put("crashTest", dofile"/lua/crashTest.lua")

--SetUserMainName("/lua/keepAliveMain.lua")

print("end lua user initialization")
