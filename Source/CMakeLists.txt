# Require a C++17 compatible compiler.
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# Turn off language extensions.
set(CMAKE_CXX_EXTENSIONS OFF)

# These compile options enforce strict warnings for project code, that won't affect dependencies.

# Add PROJECT_DEBUG define if using a debug configuration.
add_compile_definitions("$<$<CONFIG:Debug>:DEBUG>")

# Set MSVC specific compiler options.
# TODO: The clang-cl driver isn't represented here. It should have very similar options to the MSVC
# ones here, but it doesn't seem to have its own dedicated compiler ID.
if(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
  # Code Generation Options
  # Use synchronous exception handling.
  check_and_add_compile_option(/EHsc)
  # Adhere to ISO C++ volatile semantics.
  check_and_add_compile_option(/volatile:ISO)
  # Remove unreferenced inline functions/data to reduce link time and catch bugs
  check_and_add_compile_option(/Zc:inline)
  # Assume "new" (w/o std::nothrow) throws to reduce binary size.
  check_and_add_compile_option(/Zc:throwingNew)
  # Set warning level to 4.
  check_and_add_compile_option(/W4)
  # Treat warnings as errors.
  check_and_add_compile_option(/WX)
  # Adhere to ISO C++.
  check_and_add_compile_option(/permissive-)

# Set GCC/Clang compiler options.
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GCC" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  # Diagnostic Message Formatting Options  
  # Enable colored diagnostics.
  check_and_add_compile_option(-fdiagnostics-color)

  # Warning Options
  # Treat warnings as errors.
  check_and_add_compile_option(-Werror)
  # Adhere to ISO C++.
  check_and_add_compile_option(-pedantic)
  # Enable simple warnings.
  check_and_add_compile_option(-Wall)
  # Enable extra warnings.
  check_and_add_compile_option(-Wextra)
  # Enable warnings for switch cases without default cases.
  check_and_add_compile_option(-Wswitch-default)
  # Enable more uninitialized variable warnings.
  check_and_add_compile_option(-Wuninitialized)
  # Enable warnings for floating point equalities.
  check_and_add_compile_option(-Wfloat-equal)
  # Enable variable shadowing warnings.
  check_and_add_compile_option(-Wshadow)
  # Enable warnings for possibly unsafe conversions.
  check_and_add_compile_option(-Wconversion)
  # Enable warnings for using 0 instead of nullptr.
  check_and_add_compile_option(-Wzero-as-null-pointer-constant)
  # Enable warnings for missing function declarations.
  check_and_add_compile_option(-Wmissing-declarations)
  if(CMAKE_CXX_COMPILER_ID MATCHES "GCC")
    # Enable logical operator warnings.
    check_and_add_compile_option(-Wlogical-op)
  else()
    # Enable warnings for missing extern variable declarations.
    check_and_add_compile_option(-Wmissing-variable-declarations)
  endif()

  # Debugging Options
  # Produce debugging information for GDB.
  check_and_add_compile_option(-ggdb DEBUG_ONLY)
endif()

# Add the common code.
add_subdirectory(Common)
# Add the core backend.
add_subdirectory(Core)

# Add the CLI frontend, if enabled.
if (ENABLE_CLI)
  add_subdirectory(GraphicsTestCLI)
endif()