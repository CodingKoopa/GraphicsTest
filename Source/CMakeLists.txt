add_subdirectory(Common)
add_subdirectory(Core)

if (ENABLE_CLI)
  add_subdirectory(GraphicsTestCLI)
endif()