# Include CMake compiler flag utility modules.
include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

# check_and_add_compile_option(<variable> <flag> [DEBUG_ONLY | RELEASE_ONLY])
#
# Add a C or C++ compilation flag to the current scope.
#
# Use this when targeting multi-configuration generators like Visual Studio or Xcode. Configuration
# specific flags can optionally be set, using DEBUG_ONLY or RELEASE_ONLY. Release configurations
# means NOT Debug, so it will work for RelWithDebInfo or MinSizeRel too.
#
# If the flag is added successfully, the variables FLAG_C_<variable> and FLAG_CXX_<variable>
# may be set to ON.
#
# Examples:
#   check_and_add_compile_option(FOO -foo)
#   check_and_add_compile_option(ONLYDEBUG -onlydebug DEBUG_ONLY)
#   check_and_add_compile_option(OPTMAX -O9001 RELEASE_ONLY)

function(check_and_add_compile_option flag)
  if(CMAKE_CXX_COMPILER_ID MATCHES "GCC")
    set(OPTION_PREFIX_REGEX "[f|W|g]?")
  endif()
  # Strip leading prefixes. Although intuition would say that just stripping "-" would be
  # appropriate, leaving it in to where it makes the variable match the flag will result in
  # the variable having a false negative for C.
  # GCC's prefixes are -W/-g/-f, MSVC's prefixes aren't matched as they haven't caused any issues.
  string(REGEX REPLACE "^[-|/]${OPTION_PREFIX_REGEX}(.*)" "\\1" var ${flag})
  # Convert "-" and ":" to "_".
  string(REGEX REPLACE "[-|:]" "_" var ${var})
  # Convert to uppercase.
  string(TOUPPER ${var} var)

  # Default the generator expression to evaluate as true.
  set(genexp_config_test 1)
  # Require a debug configuration if desired.
  if(ARGV2 STREQUAL "DEBUG_ONLY")
    set(genexp_config_test "$<CONFIG:Debug>")
  # Require a release configuration if specified.
  elseif(ARGV2 STREQUAL "RELEASE_ONLY")
    set(genexp_config_test "$<NOT:$<CONFIG:Debug>>")
  # Handle an invalid configuration argument.
  elseif(ARGV2)
    message(FATAL_ERROR "check_and_add_compile_option called with invalid configuration.")
  endif()

  set(is_c "$<COMPILE_LANGUAGE:C>")
  set(is_cxx "$<COMPILE_LANGUAGE:CXX>")

  # The Visual Studio generators don't support COMPILE_LANGUAGE, so we fail all the C flags and
  # only actually test CXX ones.
  if(CMAKE_GENERATOR MATCHES "Visual Studio")
    set(is_c "0")
    set(is_cxx "1")
  endif()

  # Check if the C compiler accepts the flag.
  check_c_compiler_flag(${flag} FLAG_C_${var})
  # If the flag is supported, and the generator expression is true, apply the flag.
  if(FLAG_C_${var})
    add_compile_options("$<$<AND:${is_c},${genexp_config_test}>:${flag}>")
  else()
    message(VERBOSE "Flag \"${flag}\" unsupported by C compiler (FLAG_C_${var})")
  endif()

  # Check if the C++ compiler accepts the flag.
  check_cxx_compiler_flag(${flag} FLAG_CXX_${var})
  # If the flag is supported, and the generator expression is true, apply the flag.
  if(FLAG_CXX_${var})
    add_compile_options("$<$<AND:${is_cxx},${genexp_config_test}>:${flag}>")
  else()
    message(VERBOSE "Flag \"${flag}\" unsupported by C++ compiler (FLAG_CXX_${var})")
  endif()
endfunction()