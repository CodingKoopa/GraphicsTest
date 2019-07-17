# Find the CCache executable.
find_program(CCACHE_BIN ccache)

if(CCACHE_BIN)
  message(STATUS "Found CCache: ${CCACHE_BIN}")

  # Configure all builds to compile with CCache.
  set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE_BIN})
  # Configure all builds to link with CCache.
  set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ${CCACHE_BIN})
endif()
