-- This code sets up core functions and data for the Lua Robot.
-- It must never be ran more than once per run.
-- It is run automatically on boot.
-- It should usually not be modified.

print("beginning lua core initialization")

package.path = "/lua/?.lua;/lua/core/?.lua;/lua/?/init.lua;/lua/core/?/init.lua;./?.lua;./?/init.lua"

dofile"/lua/core/defaultConfig.lua"

dofile"/lua/config.lua"




print("finished lua core initialization")