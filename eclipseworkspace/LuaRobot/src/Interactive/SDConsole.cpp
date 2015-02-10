#include "SDConsole.h"

using std::cout;
using std::string;

void SDConsole::init() {
  SmartDashboard::PutBoolean("luaConsole_fresh", false);
  SmartDashboard::PutString("luaConsole_input", "");
  SmartDashboard::PutBoolean("luaFile_fresh", false);
  SmartDashboard::PutString("luaFile_name", "");
  SmartDashboard::PutNumber("luaConsole_errcode", 0);
  SmartDashboard::PutString("luaConsole_errmsg", "");
}

void SDConsole::update(lua_State *luastate) {
  if (SmartDashboard::GetBoolean("luaConsole_fresh")) {
    cout << "lua> " << SmartDashboard::GetString("luaConsole_input") << "\n";
    int errorcode = luaL_dostring(luastate, SmartDashboard::GetString("luaConsole_input").c_str());
    SmartDashboard::PutNumber("luaConsole_errcode", errorcode);
    if (errorcode > 0) {
      cout << "error code: " << errorcode << "\n";
      const char* errmsg = lua_tolstring(luastate, -1, NULL);
      cout << "error message: " << errmsg << "\n";
      SmartDashboard::PutString("luaConsole_errmsg", errmsg);
      lua_settop(luastate, 0);
    } else {
      SmartDashboard::PutString("luaConsole_errmsg", "");
    }
    SmartDashboard::PutBoolean("luaConsole_fresh", false);
  }
  if (SmartDashboard::GetBoolean("luaFile_fresh")) {
    cout << "luaFile> " << SmartDashboard::GetString("luaFile_name") << "\n";
    int errorcode = luaL_dofile(luastate, ("/lua/"+SmartDashboard::GetString("luaFile_name")+".lua").c_str());
    SmartDashboard::PutNumber("luaConsole_errcode", errorcode);
    if (errorcode > 0) {
      cout << "error code: " << errorcode << "\n";
      const char* errmsg = lua_tolstring(luastate, -1, NULL);
      cout << "error message: " << errmsg << "\n";
      SmartDashboard::PutString("luaConsole_errmsg", errmsg);
      lua_settop(luastate, 0);
    } else {
      SmartDashboard::PutString("luaConsole_errmsg", "");
    }
    SmartDashboard::PutBoolean("luaFile_fresh", false);
  }
}
