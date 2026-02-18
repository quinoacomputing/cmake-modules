################################################################################
#
# \file      FindMutationPP.cmake
# \brief     Find the Mutation++ chemical reactions library
#
################################################################################
#
# Exports:
#   MutationPP_FOUND
#   MUTATIONPP_INCLUDE_DIRS
#   MUTATIONPP_LIBRARIES
#   MUTATIONPP_DATA_DIR
#
# Target:
#   MutationPP::MutationPP  (always provided)
#
# Hints:
#   MUTATIONPP_ROOT, MPP_ROOT, TPL_DIR, CMAKE_PREFIX_PATH
#

include_guard(GLOBAL)

# ------------------------------------------------------------------------------
# Helper: create wrapper target + alias with correct naming rules
# ------------------------------------------------------------------------------

# Real (modifiable) wrapper target (no '::')
if(NOT TARGET MutationPP_wrapper)
  add_library(MutationPP_wrapper INTERFACE)
endif()

# Namespaced ALIAS target for consumers
if(NOT TARGET MutationPP::MutationPP)
  add_library(MutationPP::MutationPP ALIAS MutationPP_wrapper)
endif()

# Robustly mark include dirs as SYSTEM for consumers
function(_mpp_set_system_includes tgt)
  foreach(_inc IN LISTS ARGN)
    if(_inc)
      # Ensure it is an interface include dir
      target_include_directories(${tgt} INTERFACE "${_inc}")
      # Mark as SYSTEM so warnings from vendor headers are suppressed
      target_include_directories(${tgt} SYSTEM INTERFACE "${_inc}")
    endif()
  endforeach()

  # Extra-robust across generators: set explicit system include property
  if(ARGN)
    set_property(TARGET ${tgt} PROPERTY INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${ARGN}")
  endif()
endfunction()

# ------------------------------------------------------------------------------
# Search hints
# ------------------------------------------------------------------------------
set(_MUTATIONPP_HINTS
  "${MUTATIONPP_ROOT}"
  "${MPP_ROOT}"
  "${TPL_DIR}"
  ${CMAKE_PREFIX_PATH}
)

# ------------------------------------------------------------------------------
# 0) Prefer CONFIG-mode packages if available
# ------------------------------------------------------------------------------
set(_mpp_cfg_target "")

# Some projects install a target named "mutation++"
find_package(mutation++ CONFIG QUIET)
if(TARGET mutation++)
  set(_mpp_cfg_target mutation++)
endif()

# Others may install "Mutationpp::Mutationpp"
if(NOT _mpp_cfg_target)
  find_package(Mutationpp CONFIG QUIET)
  if(TARGET Mutationpp::Mutationpp)
    set(_mpp_cfg_target Mutationpp::Mutationpp)
  endif()
endif()

if(_mpp_cfg_target)
  # Link wrapper to the real target
  target_link_libraries(MutationPP_wrapper INTERFACE ${_mpp_cfg_target})

  # Pull include dirs from config target
  get_target_property(_mpp_inc ${_mpp_cfg_target} INTERFACE_INCLUDE_DIRECTORIES)
  if(_mpp_inc)
    set(MUTATIONPP_INCLUDE_DIRS "${_mpp_inc}")
    _mpp_set_system_includes(MutationPP_wrapper ${_mpp_inc})
  endif()

  # Best-effort library location (may be unset depending on how target is defined)
  get_target_property(_mpp_loc ${_mpp_cfg_target} IMPORTED_LOCATION)
  if(_mpp_loc)
    set(MUTATIONPP_LIBRARIES "${_mpp_loc}")
  else()
    # Some packages use IMPORTED_LOCATION_<CONFIG>
    get_target_property(_mpp_loc_rel ${_mpp_cfg_target} IMPORTED_LOCATION_RELEASE)
    if(_mpp_loc_rel)
      set(MUTATIONPP_LIBRARIES "${_mpp_loc_rel}")
    endif()
  endif()

  # Best-effort data dir discovery under known roots
  foreach(_h IN LISTS _MUTATIONPP_HINTS)
    foreach(_sfx share/mutation++/data share/Mutationpp/data data)
      if(EXISTS "${_h}/${_sfx}")
        set(MUTATIONPP_DATA_DIR "${_h}/${_sfx}")
        break()
      endif()
    endforeach()
    if(MUTATIONPP_DATA_DIR)
      break()
    endif()
  endforeach()

  set(MutationPP_FOUND TRUE)
  mark_as_advanced(MUTATIONPP_INCLUDE_DIRS MUTATIONPP_LIBRARIES MUTATIONPP_DATA_DIR)
  return()
endif()

# ------------------------------------------------------------------------------
# 1) Fallback: find headers + library manually
# ------------------------------------------------------------------------------

set(_inc_suffixes
  include
  include/mutation++
  include/Mutationpp
  mutation++/include
  Mutationpp/include
  mutationpp/include
)

find_path(MUTATIONPP_INCLUDE_DIR
  NAMES mutation++.h
  HINTS ${_MUTATIONPP_HINTS}
  PATH_SUFFIXES ${_inc_suffixes}
)

set(_lib_suffixes
  lib lib64
  mutation++/lib
  Mutationpp/lib
  mutationpp/lib
)

find_library(MUTATIONPP_LIBRARY
  NAMES mutation++ libmutation++ mutationpp libmutationpp
  HINTS ${_MUTATIONPP_HINTS}
  PATH_SUFFIXES ${_lib_suffixes}
)

# Optional data dir
foreach(_h IN LISTS _MUTATIONPP_HINTS)
  foreach(_sfx share/mutation++/data share/Mutationpp/data data)
    if(EXISTS "${_h}/${_sfx}")
      set(MUTATIONPP_DATA_DIR "${_h}/${_sfx}")
      break()
    endif()
  endforeach()
  if(MUTATIONPP_DATA_DIR)
    break()
  endif()
endforeach()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MutationPP
  REQUIRED_VARS MUTATIONPP_INCLUDE_DIR MUTATIONPP_LIBRARY
)

if(MutationPP_FOUND)
  set(MUTATIONPP_INCLUDE_DIRS "${MUTATIONPP_INCLUDE_DIR}")
  set(MUTATIONPP_LIBRARIES    "${MUTATIONPP_LIBRARY}")

  # Create imported implementation target for the actual library
  if(NOT TARGET _MutationPP_impl)
    add_library(_MutationPP_impl UNKNOWN IMPORTED)
    set_target_properties(_MutationPP_impl PROPERTIES
      IMPORTED_LOCATION "${MUTATIONPP_LIBRARY}"
    )
  endif()

  # Wrapper links to implementation and carries SYSTEM include dirs
  target_link_libraries(MutationPP_wrapper INTERFACE _MutationPP_impl)
  _mpp_set_system_includes(MutationPP_wrapper "${MUTATIONPP_INCLUDE_DIR}")
endif()

mark_as_advanced(MUTATIONPP_INCLUDE_DIR MUTATIONPP_LIBRARY MUTATIONPP_DATA_DIR)
