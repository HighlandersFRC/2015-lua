#include "LuaRobot.h"

const string LuaRobot::coreStartupName = "/lua/core/startup.lua";
const string LuaRobot::defaultUserStartupName = "/lua/startup.lua";
const string LuaRobot::defaultUserMainName = "/lua/main.lua";
const string LuaRobot::defaultStableStartupName = "/lua/stableStartup.lua";
const string LuaRobot::defaultStableMainName = "/lua/stableMain.lua";
const string LuaRobot::defaultSafemodeStartupName = "/lua/safemodeStartup.lua";
const string LuaRobot::defaultSafemodeMainName = "/lua/safemodeMain.lua";


int LuaRobot::lua_IsEnabled(lua_State *l) {
  lua_pushboolean(l, ((LuaRobot*)lua_touserdata(l, lua_upvalueindex(1)))->IsEnabled());
  return 1;
}

int LuaRobot::lua_IsDisabled(lua_State *l) {
  lua_pushboolean(l, ((LuaRobot*)lua_touserdata(l, lua_upvalueindex(1)))->IsDisabled());
  return 1;
}

int LuaRobot::lua_IsAutonomous(lua_State *l) {
  lua_pushboolean(l, ((LuaRobot*)lua_touserdata(l, lua_upvalueindex(1)))->IsAutonomous());
  return 1;
}

int LuaRobot::lua_IsOperatorControl(lua_State *l) {
  lua_pushboolean(l, ((LuaRobot*)lua_touserdata(l, lua_upvalueindex(1)))->IsOperatorControl());
  return 1;
}

int LuaRobot::lua_IsTest(lua_State *l) {
  lua_pushboolean(l, ((LuaRobot*)lua_touserdata(l, lua_upvalueindex(1)))->IsTest());
  return 1;
}

int LuaRobot::lua_IsSystemActive(lua_State *l) {
  lua_pushboolean(l, ((LuaRobot*)lua_touserdata(l, lua_upvalueindex(1)))->IsSystemActive());
  return 1;
}

int LuaRobot::lua_IsNewDataAvailable(lua_State *l) {
  lua_pushboolean(l, ((LuaRobot*)lua_touserdata(l, lua_upvalueindex(1)))->IsNewDataAvailable());
  return 1;
}

void LuaRobot::RestartLua() {
  crashCount = 0;
  longjmp(restartLuaJmpBuf, 1);
}

int LuaRobot::lua_RestartLua(lua_State *l) {
  ((LuaRobot*)lua_touserdata(l, lua_upvalueindex(1)))->RestartLua();
  return 0;
}

void LuaRobot::SetUserStartupName(string name) {
  userStartupName = name;
}

int LuaRobot::lua_SetUserStartupName(lua_State *l) {
  ((LuaRobot*)lua_touserdata(l, lua_upvalueindex(1)))->SetUserStartupName(lua_tostring(l, -1));
  return 0;
}

void LuaRobot::SetUserMainName(string name) {
  userMainName = name;
}

int LuaRobot::lua_SetUserMainName(lua_State *l) {
  ((LuaRobot*)lua_touserdata(l, lua_upvalueindex(1)))->SetUserMainName(lua_tostring(l, -1));
  return 0;
}

luaL_Reg LuaRobot::stateFunctions[] = {
  {"IsEnabled", &LuaRobot::lua_IsEnabled}, 
  {"IsDisabled", &LuaRobot::lua_IsDisabled},
  {"IsAutonomous", &LuaRobot::lua_IsAutonomous},
  {"IsOperatorControl", &LuaRobot::lua_IsOperatorControl},
  {"IsTest", &LuaRobot::lua_IsTest},
  {"IsSystemActive", &LuaRobot::lua_IsSystemActive},
  {"IsNewDataAvailable", &LuaRobot::lua_IsNewDataAvailable},
  {NULL, NULL}
};

luaL_Reg LuaRobot::interactionFunctions[] = {
  {"Restart", &LuaRobot::lua_RestartLua},
  {"SetUserStartupName", &LuaRobot::lua_SetUserStartupName},
  {"SetUserMainName", &LuaRobot::lua_SetUserMainName},
  {NULL, NULL}
};

void LuaRobot::LuaInit() {
  //cout << "Begin stuff...\n";
  //luaConsole->init();
  luaL_openlibs(LuaRobot::luastate);
  luaopen_WPILib(LuaRobot::luastate);
  lua_pushglobaltable(LuaRobot::luastate);
  lua_pushlightuserdata(luastate, this);
  luaL_setfuncs(luastate, LuaRobot::stateFunctions, 1);
  lua_pushlightuserdata(luastate, this);
  luaL_setfuncs(luastate, LuaRobot::interactionFunctions, 1);
  lua_getfield(luastate, -1, "package");
  lua_remove(luastate, -2);
  lua_getfield(luastate, -1, "preload");
  lua_pushcfunction(luastate, luaopen_socket_core);
  lua_setfield(luastate, -2, "socket.core");
  lua_remove(luastate, -1);
  if (crashCount <= 2) {
    userStartupName = defaultUserStartupName;
  }
  cout << "begin coreInit\n";
  int errorcode = luaL_dofile(LuaRobot::luastate, coreStartupName.c_str());
  if (errorcode > 0) {
    cout << "file name: " << coreStartupName << "\n";
    cout << "error code: " << errorcode << "\n";
    cout << "error message: " << lua_tolstring(luastate, -1, NULL) << "\n";
    lua_settop(luastate, 0);
  }
  cout << "end coreInit\nbegin userInit\n";
  if (crashCount > 2 && crashCount <= 4) {
    userStartupName = defaultStableStartupName;
  }
  if (crashCount > 4) {
    userStartupName = defaultSafemodeStartupName;
  }
  errorcode = luaL_dofile(LuaRobot::luastate, userStartupName.c_str());
  if (errorcode > 0) {
    cout << "file name: " << userStartupName << "\n";
    cout << "error code: " << errorcode << "\n";
    cout << "error message: " << lua_tolstring(luastate, -1, NULL) << "\n";
    lua_settop(luastate, 0);
  }
  cout << "end userInit\n";
}

void LuaRobot::StartCompetition() {
  userStartupName = defaultUserStartupName;
  userMainName = defaultUserMainName;
  crashCount = 0;
  if (setjmp(restartLuaJmpBuf)) {
    lua_close(luastate);
  }
  luastate = luaL_newstate();
  if (crashCount <= 2) {
    userMainName = defaultUserMainName;
  }
  LuaInit();
  //luaConsole->init();
  //SmartDashboard::PutBoolean("lua_reset", false);
  if (crashCount > 2 && crashCount <= 4) {
    userMainName = defaultStableMainName;
  }
  if (crashCount > 4) {
    userMainName = defaultSafemodeMainName;
  }
  cout << "Starting Main...\n";
  int errorcode = luaL_dofile(LuaRobot::luastate, userMainName.c_str());
  if (errorcode > 0) {
    cout << "error code: " << errorcode << "\n";
    cout << "error message: " << lua_tolstring(luastate, -1, NULL) << "\n";
    lua_settop(luastate, 0);
  }
  cout << "Main Terminated.\n";  
  ++crashCount;
  longjmp(restartLuaJmpBuf, 1);
  cout << "Past Jump point.";
}

START_ROBOT_CLASS(LuaRobot);
