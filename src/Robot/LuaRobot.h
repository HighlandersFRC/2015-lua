#include "WPILib.h"
#include "lua.hpp"
#include "Interactive/SDConsole.h"
#include <RobotBase.h>
#include "setjmp.h"

extern "C" {
#include "luasocket.h"
void luaopen_WPILib(lua_State*);
}

class LuaRobot : public RobotBase {

private:
  lua_State *luastate;
  int robotstate;
  SDConsole* luaConsole;
  static luaL_Reg stateFunctions[];
  static const string defaultUserStartupName;
  static const string defaultUserMainName;
  static const string defaultStableStartupName;
  static const string defaultStableMainName;
  static const string defaultSafemodeStartupName;
  static const string defaultSafemodeMainName;
  int crashCount;
  string userStartupName;
  string userMainName;
  jmp_buf restartLuaJmpBuf;

  static luaL_Reg interactionFunctions[];

  virtual void LuaInit();
  virtual void StartCompetition();

  static int lua_IsEnabled(lua_State *l);
  static int lua_IsDisabled(lua_State *l);
  static int lua_IsAutonomous(lua_State *l);
  static int lua_IsOperatorControl(lua_State *l);
  static int lua_IsTest(lua_State *l);
  static int lua_IsSystemActive(lua_State *l);
  static int lua_IsNewDataAvailable(lua_State *l);

  void RestartLua();
  static int lua_RestartLua(lua_State *l);
  void SetUserStartupName(string name);
  static int lua_SetUserStartupName(lua_State *l);
  void SetUserMainName(string name);
  static int lua_SetUserMainName(lua_State *l);

  // virtual void LuaRobotCall(int mode, int event) {
  //   lua_pushglobaltable(luastate);
  //   lua_getfield(luastate, -1, "Robot");
  //   lua_remove(luastate, -2);
  //   if (mode == 1) {
  //     lua_getfield(luastate, -1, "Autonomous");
  //   } else if (mode == 2) {
  //     lua_getfield(luastate, -1, "Teleop");
  //   } else {
  //     lua_getfield(luastate, -1, "Disabled");
  //   }
  //   lua_remove(luastate, -2);
  //   if (event == 0) {
  //     lua_getfield(luastate, -1, "Initialize");
  //   } else if (event == 1) {
  //     lua_getfield(luastate, -1, "Execute");
  //   } else {
  //     lua_getfield(luastate, -1, "End");
  //   }
  //   if (lua_isnil(luastate, -1)) {
  //     lua_remove(luastate, -1);
  //     lua_remove(luastate, -1);
  //     return;
  //   }
  //   lua_insert(luastate, -2);
  //   int errorcode = lua_pcall(luastate, 1, 0, 0);
  //   if (errorcode > 0) {
  //     cout << "error code: " << errorcode << "\n";
  //     cout << "error message: " << lua_tolstring(luastate, -1, NULL) << "\n";
  //     lua_settop(luastate, 0);
  //   }
  // }
  
  // virtual void RobotInit() {
  //   robotstate = 0;
  //   luastate = luaL_newstate();
  //   LuaInit();
  //   luaConsole->init();
  //   SmartDashboard::PutBoolean("lua_reset", false);
  // }

  // virtual void AutonomousInit() {
  //   LuaRobotCall(0, 2);
  //   robotstate = 1;
  //   LuaRobotCall(1, 0);
  // }

  // virtual void AutonomousPeriodic() {
  //   LuaRobotCall(1, 1);
  //   luaConsole->update(luastate);
  // }

  // virtual void TeleopInit() {
  //   LuaRobotCall(0, 2);
  //   robotstate = 2;
  //   LuaRobotCall(2, 0);
  // }

  // virtual void TeleopPeriodic() {
  //   LuaRobotCall(2, 1);
  //   luaConsole->update(luastate);
  // }

  // virtual void TestPeriodic() {
  //   //lw->Run();
  // }

  // virtual void DisabledInit() {
  //   LuaRobotCall(robotstate, 2);
  //   robotstate = 0;
  //   LuaRobotCall(0, 0);
  // }

  //lua_cfunction 




  // virtual void DisabledPeriodic() {
  //   LuaRobotCall(0, 1);
  //   luaConsole->update(luastate);
  //   if (SmartDashboard::GetBoolean("lua_reset")) {
  //     lua_close(luastate);
  //     luastate = luaL_newstate();
  //     LuaInit();
  //     SmartDashboard::PutBoolean("lua_reset", false);
  //   }
  // }

};
