# Set the minimum required CMake version to 3.8, because C++17 support is required.
cmake_minimum_required(VERSION 3.8)

# Set the project info.
project(graphics-test
        VERSION "1.0"
        DESCRIPTION "3D Graphics Experiment"
        HOMEPAGE_URL "https://gitlab.com/CodingKoopa/graphics-test"
)

# Set option defaults. If any options are removed/modified/added, "cmake-variants.yaml" should be
# updated.
option(ENABLE_CLI "Enable CLI frontend" ON)

# Enable folders for IDEs.
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Setup build output paths.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/Binaries)

# Setup installation output paths.
set(PROJECT_INSTALL_BIN_DIR ${CMAKE_INSTALL_PREFIX}/bin CACHE PATH "Directory to store binaries in.")

# Import project CMake modules.
list(APPEND CMAKE_MODULE_PATH
  ${CMAKE_SOURCE_DIR}/CMakeModules
)

# Include project functions.
include(CheckAndAddCompileOption)

# Setup CCache.
include(CCache)

# Setup Git versioning.
include(GitVersioning)

# If a Git repository was detected.
if(PROJECT_COMMIT)
  # If this isn't a stable build, adjust the patch to be the commit hash.
  if(NOT PROJECT_BRANCH STREQUAL "stable")
    set(PROJECT_VERSION_PATCH "${PROJECT_COMMIT}")
  endif()
# If not building in a Git repo, default the version info to reasonable values.
else()
  set(PROJECT_BRANCH "master")
  set(PROJECT_DESCRIPTION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}")
  set(PROJECT_COMMIT "${PROJECT_DESCRIPTION} (no further info)")
endif()

# Enable multiple process building for MSVC.
if(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
  check_and_add_compile_option(/MP)
endif()

# Require a C++17 compatible compiler.
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# Turn off language extensions.
set(CMAKE_CXX_EXTENSIONS OFF)

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

# Insert dependencies.

# Process project source includes. Do this before processing external includes to ensure that
# these are preferred.
include_directories(Source)

# Process the external code.

add_subdirectory(Externals/spdlog)
include_directories(Externals/spdlog/include)

# Generate SCM header.
configure_file(
  "${PROJECT_SOURCE_DIR}/Source/Common/SCM.h.in"
  "${PROJECT_BINARY_DIR}/Source/Common/SCM.h"
)
# Process project binary includes, for generated headers. Although this path could be made more
# specific, given this is only really needed for the SCM header, including all of the Source
# directory ensures that the #include line will make sense.
include_directories("${PROJECT_BINARY_DIR}/Source/")

# Process the project code.
add_subdirectory(Source)