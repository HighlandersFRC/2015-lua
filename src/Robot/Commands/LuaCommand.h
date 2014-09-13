#include "lua.hpp"
#include "WPILib.h"

class LuaCommand : public Command {
 public:
 LuaCommand(*LuaState);
};
