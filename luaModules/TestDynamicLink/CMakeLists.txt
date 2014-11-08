cmake_minimum_required(VERSION 2.8)

include(../LuaDeploy.cmake)

project(LinkTest)

file(GLOB_RECURSE LINKTEST_LUA_CODE *.lua)

set_lua_startup(LinkTest TestDynamicLink.lua)

add_make_lua_deploy(LinkTest 10.44.99.2 ${LINKTEST_LUA_CODE})