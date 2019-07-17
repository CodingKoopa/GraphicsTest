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
  ${CMAKE_SOURCE_DIR}/CMake
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

# Insert dependencies.

# Process project source includes. Do this before processing external includes to ensure that
# these are preferred.
include_directories(Source)

# Insert externals here.

# Generate SCM header.
configure_file(
  "${PROJECT_SOURCE_DIR}/Source/Common/SCM.h.in"
  "${PROJECT_BINARY_DIR}/Source/Common/SCM.h"
)
# Process project binary includes, for generated headers. Although this path could be made more
# specific, given this is only really needed for the SCM header, including all of the Source
# directory ensures that the #include line will make sense.
include_directories("${PROJECT_BINARY_DIR}/Source/")

# Process the source directory.
add_subdirectory(Source)