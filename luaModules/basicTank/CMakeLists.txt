cmake_minimum_required(VERSION 2.8)

include(../LuaDeploy.cmake)

project(BasicTank)

file(GLOB_RECURSE BASICTANK_LUA_CODE *.lua)

set_lua_startup(BasicTank basicTank.lua)

add_make_lua_deploy(BasicTank 10.44.99.2 ${BASICTANK_LUA_CODE})