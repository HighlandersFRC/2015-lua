#include "WPILib.h"
#include "lua.hpp"

class SDConsole {
 public:
  void init();
  void update(lua_State*);
};
