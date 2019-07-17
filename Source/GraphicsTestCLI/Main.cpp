// Copyright 2019 Graphics Test Project
// Licensed under GPLv3
// Refer to license.txt file included.

#include <iostream>

#include "Common/Version.hpp"

#include "Core/Core.hpp"

int main()
{
  std::cout << Common::scm_version_str << std::endl;

  return Core::Init();
}