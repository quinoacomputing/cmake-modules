# Set the default value for building shared libs if none was specified
set(BUILD_SHARED_LIBS ON CACHE BOOL "Build shared libraries. Possible values: ON | OFF")
if(NOT DEFINED BUILD_SHARED_LIBS)
  message(STATUS "BUILD_SHARED_LIBS not specified, setting to 'ON'")
else()
  if(NOT BUILD_SHARED_LIBS AND
     NOT "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU" AND
     NOT ${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    message(STATUS "Static linking only supported with the GNU compiler suite, overriding BUILD_SHARED_LIBS = off -> on")
    set(BUILD_SHARED_LIBS on)
  endif()
  message(STATUS "BUILD_SHARED_LIBS: ${BUILD_SHARED_LIBS}")
endif()
