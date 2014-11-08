cmake_minimum_required(VERSION 2.8)

include(FRCDeploy)

project(RobotLua)
find_package(WPILib)
include_directories(${WPILib_INCLUDE_DIRS} ${RobotLua_SOURCE_DIR}/../lua ${RobotLua_SOURCE_DIR} ${RobotLua_SOURCE_DIR}/../lua_sockets)

file(GLOB_RECURSE ROBOT_SOURCE_CODE *.cpp *.c ../lua/*.c ../lua_sockets/*.c)

set(VXWORKS_COMPILE_FLAGS ${VXWORKS_COMPILE_FLAGS} -DLUA_USE_DLOPEN -DLUA_PATH_DEFAULT="/lua/?.lua;/lua/?/init.lua;./?.lua" -DLUA_CPATH_DEFAULT="/lua/?.out;./?.out")

add_executable(LuaRobot ${ROBOT_SOURCE_CODE})
target_link_libraries(LuaRobot ${WPILib_LIBRARY})

add_make_deploy(LuaRobot 10.44.99.2)
