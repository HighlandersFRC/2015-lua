cmake_minimum_required(VERSION 2.8)

include(../LuaDeploy)

project(Generate_WPILib_API)

file(Generate_WPILib_API_LUA_FILES init.lua)

set_lua_startup(Generate_WPILib_API init.lua)

add_make_lua_deploy(Generate_WPILib_API 10.44.99.2 ${Generate_WPILib_API_LUA_FILES})