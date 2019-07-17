# Add the core library target.
add_library(core
            Core.hpp
            Core.cpp
)

# Link the library dependencies.
target_link_libraries(core
                      PUBLIC
                        common
)