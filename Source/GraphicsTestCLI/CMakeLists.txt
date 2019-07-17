# Add the graphics test CLI executable target.
add_executable(graphics-test-cli
               Main.cpp
)

# Link the core backend library.
target_link_libraries(graphics-test-cli
											PRIVATE
												core
)

install(TARGETS graphics-test-cli DESTINATION ${PROJECT_INSTALL_BIN_DIR})