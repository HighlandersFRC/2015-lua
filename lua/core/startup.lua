-- This code sets up core functions and data for the Lua Robot.
-- It must never be ran more than once per run.
-- It is run automatically on boot.
-- It should usually not be modified.

print("beginning lua core initialization")

package.path = "/home/lvuser/lua/?.lua;/home/lvuser/lua/core/?.lua;/home/lvuser/lua/?/init.lua;/home/lvuser/lua/core/?/init.lua;./?.lua;./?/init.lua"
package.cpath = "/home/lvuser/lua/?.so"

dofile"/home/lvuser/lua/core/defaultConfig.lua"

dofile"/home/lvuser/lua/config.lua"

debugPrint = function(...)
  checkWPILib"beginning of debugPrint"
  if enableDebug then print(...) end
  checkWPILib"end of debugPrint"
end


print("finished lua core initialization")