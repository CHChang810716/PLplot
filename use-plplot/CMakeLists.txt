cmake_minimum_required(VERSION 3.10)
project(use-plplot)
find_package(plplot CONFIG REQUIRED)
add_executable(plplot_test plplot_test.cpp) # An executable target
target_link_libraries(plplot_test PLPLOT::plplot PLPLOT::plplotcxx)