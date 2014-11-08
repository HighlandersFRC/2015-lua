cmake_minimum_required(VERSION 2.8)

include(FRCDeploy)

project(DynamicLinkTest)
include_directories(${DynamicLinkTest_SOURCE_DIR}/../lua ${DynamicLinkTest_SOURCE_DIR})

file(GLOB_RECURSE DYNAMICTEST_SOURCE_CODE *.cpp *.c)

add_executable(DynamicLinkTest ${DYNAMICTEST_SOURCE_CODE})

set(DEPLOY_PATH /lua/)
add_custom_command(OUTPUT deploy_stamp
  COMMAND wput -u DynamicLinkTest ftp://anonymous@10.44.99.2${DEPLOY_PATH}DynamicLinkTest.out
  DEPENDS DynamicLinkTest
  VERBATIM)
set_source_files_properties(deploy_stamp PROPERTIES SYMBOLIC true)
add_custom_target(deploy DEPENDS deploy_stamp)