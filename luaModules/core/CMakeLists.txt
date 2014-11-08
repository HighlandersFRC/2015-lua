include(../LuaDeploy.cmake)

project(LuaCore)

file(GLOB_RECURSE CORE_FILES *.lua)

add_make_lua_deploy(LuaCore 10.44.99.2 ${CORE_FILES})