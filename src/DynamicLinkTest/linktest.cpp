#include <stdio.h>
#include <stdlib.h>
#include "lua.hpp"
extern "C" {
  int dynamicallyLinkedTest(lua_State *l) {
    printf("This code was dynamically loaded\n");
    lua_pushstring(l, "This code was dynamically loaded");
    return 1;
  }
  static luaL_Reg dynamiclinktestfunctions[] = {
    {"dynamicallyLinkedTest", &dynamicallyLinkedTest},
    {NULL, NULL}
  };
  int luaopen_DynamicLinkTest(lua_State *l) {
    lua_newtable(l);
    luaL_setfuncs(l, dynamiclinktestfunctions, 0);
    return 1;
  }
}
