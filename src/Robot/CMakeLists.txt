cmake_minimum_required(VERSION 2.8)

project(RobotLua)
include_directories(~/wpilib/cpp/current/include  ${RobotLua_SOURCE_DIR}/../lua ${RobotLua_SOURCE_DIR} ${RobotLua_SOURCE_DIR}/../lua_sockets)

file(GLOB_RECURSE ROBOT_SOURCE_CODE *.cpp *.c ../lua/*.c ../lua_sockets/*.c)

set(COMPILE_FLAGS ${COMPILE_FLAGS} -DLUA_USE_DLOPEN -L~/wpilib/cpp/current/lib -std=c++11)

add_executable(LuaRobot ${ROBOT_SOURCE_CODE})
target_link_libraries(LuaRobot wpi_2015)
