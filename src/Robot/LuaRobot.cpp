#include "LuaRobot.h"

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

void LuaRobot::LuaInit() {
  //cout << "Begin stuff...\n";
  //luaConsole->init();
  luaL_openlibs(LuaRobot::luastate);
  luaopen_WPILib(LuaRobot::luastate);
  lua_pushglobaltable(LuaRobot::luastate);
  //cout << "Before push light.\n";
  lua_pushlightuserdata(luastate, this);
  //cout << "Before set functions...\n";
  luaL_setfuncs(luastate, LuaRobot::stateFunctions, 1);
  //cout << "After set functions.\n";
  lua_getfield(luastate, -1, "package");
  lua_remove(luastate, -2);
  lua_getfield(luastate, -1, "preload");
  lua_pushcfunction(luastate, luaopen_socket_core);
  lua_setfield(luastate, -2, "socket.core");
  lua_remove(luastate, -1);
  cout << "begin coreInit\n";
  int errorcode = luaL_dofile(LuaRobot::luastate, "/lua/core/startup.lua");
  if (errorcode > 0) {
    cout << "error code: " << errorcode << "\n";
    cout << "error message: " << lua_tolstring(luastate, -1, NULL) << "\n";
    lua_settop(luastate, 0);
  }
  cout << "end coreInit\nbegin userInit\n";
  errorcode = luaL_dofile(LuaRobot::luastate, "/lua/startup.lua");
  if (errorcode > 0) {
    cout << "error code: " << errorcode << "\n";
    cout << "error message: " << lua_tolstring(luastate, -1, NULL) << "\n";
    lua_settop(luastate, 0);
  }
  cout << "end userInit\n";
}

void LuaRobot::StartCompetition() {
  luastate = luaL_newstate();
  LuaInit();
  //luaConsole->init();
  //SmartDashboard::PutBoolean("lua_reset", false);
  cout << "Starting Main...\n";
  int errorcode = luaL_dofile(LuaRobot::luastate, "/lua/main.lua");
  if (errorcode > 0) {
    cout << "error code: " << errorcode << "\n";
    cout << "error message: " << lua_tolstring(luastate, -1, NULL) << "\n";
    lua_settop(luastate, 0);
  }
  cout << "Main Terminated.\n";
}

START_ROBOT_CLASS(LuaRobot);
