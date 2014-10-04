-- This code is for custom robot initialization.
-- It is automatically run on boot.
-- It can safely be modified to load robot programs.
-- Setting up the hardware and control mapping belongs elsewhere.

print("beginning lua user initialization")

--require("mobdebug").start("10.44.99.100")
dofile("/lua/basicTank.lua")

print("end lua user initialization")
