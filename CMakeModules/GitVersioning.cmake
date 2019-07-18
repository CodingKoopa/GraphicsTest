# This module defines:
# - PROJECT_BRANCH
# - PROJECT_DESCRIPTION
# - PROJECT_COMMIT

# Find the Git CMake package.
find_package(Git)

if(GIT_FOUND)
  # Resolves the Git path to the HEAD reference.
  execute_process(COMMAND ${GIT_EXECUTABLE} rev-parse --git-path HEAD
                  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                  OUTPUT_VARIABLE GIT_HEAD_REF_PATH
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  # Add the HEAD file to the list of CMake configure dependencies. Given the HEAD file contains the
  # symbolic reference to the current branch, this will make CMake update when the Git branch has
  # changed. For more info, see:
  # - https://git-scm.com/book/en/v2/Git-Internals-Git-References
  # - https://github.com/dolphin-emu/dolphin/pull/4841
  set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${GIT_HEAD_REF_PATH}")

  # Dereference the HEAD symbolic reference to get the Git path to the current branch reference.
  execute_process(COMMAND ${GIT_EXECUTABLE} rev-parse --symbolic-full-name HEAD
                  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                  OUTPUT_VARIABLE GIT_BRANCH_REF
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  # Resolve the Git path to the branch reference.
  execute_process(COMMAND ${GIT_EXECUTABLE} rev-parse --git-path ${GIT_BRANCH_REF}
                  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                  OUTPUT_VARIABLE GIT_BRANCH_REF_PATH
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  # Add the branch reference to the list of CMake configure dependencies. Given the branch
  # reference contains the SHA-1 hash of the current commit, this will make CMake update when a
  # new Git commit has been made, rebasing has taken place, or other commit related actions
  # take place. For more info, see:
  # - https://github.com/dolphin-emu/dolphin/pull/4844
  set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${GIT_BRANCH_REF_PATH}")

  # Gets the current Git branch.
  execute_process(COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
                  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR} 
                  OUTPUT_VARIABLE PROJECT_BRANCH
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  # Gets the current Git description of HEAD, including the working tree state, and long format
  # description.
  execute_process(COMMAND ${GIT_EXECUTABLE} describe --dirty --long --always
                  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                  OUTPUT_VARIABLE PROJECT_DESCRIPTION
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  # Remove the commit hash (and trailing "-0" if needed) from the description.
  string(REGEX REPLACE "(-0)?-[^-]+((-dirty)?)$" "\\2"
         PROJECT_DESCRIPTION "${PROJECT_DESCRIPTION}")

  # Gets the current Git commit.
  execute_process(COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
                  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR} 
                  OUTPUT_VARIABLE PROJECT_COMMIT
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()