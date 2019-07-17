// Copyright 2019 Graphics Test Project
// Licensed under GPLv3
// Refer to license.txt file included.

#include "Common/Version.hpp"

#include <string>

#include "Common/SCM.h"

namespace Common
{
const std::string scm_version_str = "Graphics Test " PROJECT_DESC_STR;
const std::string scm_branch_str = PROJECT_BRANCH_STR;
const std::string scm_desc_str = PROJECT_DESC_STR;
const std::string scm_commit_str = PROJECT_COMMIT_STR;
}