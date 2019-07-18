add_executable(graphics-test-cli
               Main.cpp
)

target_link_libraries(graphics-test-cli
											PRIVATE
												core
												spdlog
)

install(TARGETS graphics-test-cli DESTINATION ${PROJECT_INSTALL_BIN_DIR})