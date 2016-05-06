################################################################################
#
# \file      cmake/ConfigureDataLayout.cmake
# \author    J. Bakosi
# \copyright 2012-2015, Jozsef Bakosi, 2016, Los Alamos National Security, LLC.
# \brief     Configure data layouts
# \date      Fri 06 May 2016 06:41:06 AM MDT
#
################################################################################

# Configure data layout for particle data

# Available options
set(PARTICLE_DATA_LAYOUT_VALUES "particle" "equation")
# Initialize all to off
set(PARTICLE_DATA_LAYOUT_AS_PARTICLE_MAJOR off)  # 0
set(PARTICLE_DATA_LAYOUT_AS_EQUATION_MAJOR off)  # 1
# Set default and select from list
set(PARTICLE_DATA_LAYOUT "particle" CACHE STRING "Particle data layout. Default: (particle-major). Available options: ${PARTICLE_DATA_LAYOUT_VALUES}(-major).")
SET_PROPERTY (CACHE PARTICLE_DATA_LAYOUT PROPERTY STRINGS ${PARTICLE_DATA_LAYOUT_VALUES})
STRING (TOLOWER ${PARTICLE_DATA_LAYOUT} PARTICLE_DATA_LAYOUT)
LIST (FIND PARTICLE_DATA_LAYOUT_VALUES ${PARTICLE_DATA_LAYOUT} PARTICLE_DATA_LAYOUT_INDEX)
# Evaluate selected option and put in a define for it
IF (${PARTICLE_DATA_LAYOUT_INDEX} EQUAL 0)
  set(PARTICLE_DATA_LAYOUT_AS_PARTICLE_MAJOR on)
ELSEIF (${PARTICLE_DATA_LAYOUT_INDEX} EQUAL 1)
  set(PARTICLE_DATA_LAYOUT_AS_EQUATION_MAJOR on)
ELSEIF (${PARTICLE_DATA_LAYOUT_INDEX} EQUAL -1)
  MESSAGE(FATAL_ERROR "Particle data layout '${PARTICLE_DATA_LAYOUT}' not supported, valid entries are ${PARTICLE_DATA_LAYOUT_VALUES}(-major).")
ENDIF()
message(STATUS "Particle data layout (PARTICLE_DATA_LAYOUT): " ${PARTICLE_DATA_LAYOUT} "(-major)")

# Configure data layout for mesh node data

# Available options
set(MESHNODE_DATA_LAYOUT_VALUES "meshnode" "equation")
# Initialize all to off
set(MESHNODE_DATA_LAYOUT_AS_MESHNODE_MAJOR off)  # 0
set(MESHNODE_DATA_LAYOUT_AS_EQUATION_MAJOR off)  # 1
# Set default and select from list
set(MESHNODE_DATA_LAYOUT "meshnode" CACHE STRING "Mesh node data layout. Default: (meshnode-major). Available options: ${MESHNODE_DATA_LAYOUT_VALUES}(-major).")
SET_PROPERTY (CACHE MESHNODE_DATA_LAYOUT PROPERTY STRINGS ${MESHNODE_DATA_LAYOUT_VALUES})
STRING (TOLOWER ${MESHNODE_DATA_LAYOUT} MESHNODE_DATA_LAYOUT)
LIST (FIND MESHNODE_DATA_LAYOUT_VALUES ${MESHNODE_DATA_LAYOUT} MESHNODE_DATA_LAYOUT_INDEX)
# Evaluate selected option and put in a define for it
IF (${MESHNODE_DATA_LAYOUT_INDEX} EQUAL 0)
  set(MESHNODE_DATA_LAYOUT_AS_MESHNODE_MAJOR on)
ELSEIF (${MESHNODE_DATA_LAYOUT_INDEX} EQUAL 1)
  set(MESHNODE_DATA_LAYOUT_AS_EQUATION_MAJOR on)
ELSEIF (${MESHNODE_DATA_LAYOUT_INDEX} EQUAL -1)
  MESSAGE(FATAL_ERROR "Mesh node data layout '${MESHNODE_DATA_LAYOUT}' not supported, valid entries are ${MESHNODE_DATA_LAYOUT_VALUES}(-major).")
ENDIF()
message(STATUS "Mesh node data layout (MESHNODE_DATA_LAYOUT): " ${MESHNODE_DATA_LAYOUT} "(-major)")
