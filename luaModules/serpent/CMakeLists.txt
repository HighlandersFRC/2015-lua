cmake_minimum_required(VERSION 2.8)

include(../LuaDeploy.cmake)

project(serpent)

files(SERPENT_CODE serpent.lua)

add_make_lua_deploy(serpent 10.44.99.2 ${SERPENT_CODE})
