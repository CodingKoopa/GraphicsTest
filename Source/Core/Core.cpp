// Copyright 2019 Graphics Test Project
// Licensed under GPLv3
// Refer to license.txt file included.

#include "Core.hpp"

#include <iostream>

namespace Core
{
bool Init()
{
  std::cout << "Core initialized!" << std::endl;
#ifdef DEBUG
  std::cout << "Running in debug mode." << std::endl;
#endif

  return true;
}

}  // namespace Core