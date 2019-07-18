// Copyright 2019 Graphics Test Project
// Licensed under GPLv3
// Refer to license.txt file included.

#include "Core.hpp"

#include "Common/Version.hpp"

#include <spdlog/spdlog.h>

namespace Core
{
bool Init()
{
  spdlog::info("Core initialized!");
#ifdef DEBUG
  spdlog::info("Running in debug mode.");
#endif

  return true;
}

}  // namespace Core