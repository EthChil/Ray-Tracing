cmake_minimum_required(VERSION 2.8.4)
project(WhittedProper)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE
        Core.cpp)
set(HEADERS
        Core.hpp)

add_executable(${PROJECT_NAME} main.cpp)

add_library(Core STATIC Core.cpp Core.hpp)

target_link_libraries(${PROJECT_NAME} Core)