add_library(core
            Core.hpp
            Core.cpp
)

target_link_libraries(core
                      PUBLIC
                        common
)