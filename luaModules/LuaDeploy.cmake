macro(set_lua_startup Target File)
  set(${Target}_lua_startup ${File})
endmacro(set_lua_startup)

macro(add_make_lua_deploy TGT IP)
  set(DEPLOY_PATH /lua/${TGT}/)
  set(DEPLOY_STAMPS_LIST )
  foreach(sourcefile ${ARGN})
    file(RELATIVE_PATH deployfile ${CMAKE_CURRENT_SOURCE_DIR} ${sourcefile})
    add_custom_command(OUTPUT ${deployfile}_deploy_stamp
      COMMAND wput -u ${sourcefile} ftp://anonymous@${IP}${DEPLOY_PATH}${deployfile}
      DEPENDS ${deployfile}
      VERBATIM)
    set_source_files_properties(${deployfile}_deploy_stamp PROPERTIES SYMBOLIC true)
    set(DEPLOY_STAMPS_LIST ${DEPLOY_STAMPS_LIST} ${deployfile}_deploy_stamp)
  endforeach(sourcefile)
  if(${TGT}_lua_startup)
    add_custom_command(OUTPUT startup.lua_deploy_stamp
      COMMAND echo dofile\"${DEPLOY_PATH}${${TGT}_lua_startup}\" > startup.lua
      COMMAND wput -u startup.lua ftp://anonymous@${IP}/lua/startup.lua
      VERBATIM)
    set_source_files_properties(startup.lua_deploy_stamp PROPERTIES SYMBOLIC true)
    set(DEPLOY_STAMPS_LIST ${DEPLOY_STAMPS_LIST} startup.lua_deploy_stamp)
  endif(${TGT}_lua_startup)
  set(UNDEPLOY_STAMPS_LIST )
  add_custom_target(deploy DEPENDS ${DEPLOY_STAMPS_LIST})
  add_custom_command(OUTPUT undeploy_stamp
    COMMAND wdel ftp://anonymous@${IP}${DEPLOY_PATH}
    VERBATIM)
  set(UNDEPLOY_STAMPS_LIST ${UNDEPLOY_STAMPS_LIST} undeploy_stamp)
  if(${TGT}_lua_startup)
    add_custom_command(OUTPUT startup.lua_undeploy_stamp
      COMMAND echo print\"***No robot code deployed***\" > nostartup.lua
      COMMAND echo Robot={Disabled={},Autonomous={},Teleop={}} >> nostartup.lua
      COMMAND wput -u nostartup.lua ftp://anonymous@${IP}/lua/startup.lua
      VERBATIM)
    set(UNDEPLOY_STAMPS_LIST ${UNDEPLOY_STAMPS_LIST} startup.lua_undeploy_stamp)
  endif(${TGT}_lua_startup)
  add_custom_target(undeploy DEPENDS ${UNDEPLOY_STAMPS_LIST})
endmacro(add_make_lua_deploy)