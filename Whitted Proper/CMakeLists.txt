cmake_minimum_required(VERSION 2.8.4)
project(WhittedProper)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE
        Core.cpp)
set(HEADERS
        Core.hpp)

add_executable(${PROJECT_NAME} main.cpp)

add_library(Point STATIC Core/Point.cpp Core/Point.hpp)
add_library(Vector STATIC Core/Vector.cpp Core/Vector.hpp)
add_library(Normal STATIC Core/Normal.cpp Core/Normal.hpp)
add_library(Ray STATIC Core/Ray.cpp Core/Ray.hpp)
add_library(Bound STATIC Core/Bound.cpp Core/Bound.hpp)

target_link_libraries(${PROJECT_NAME} Point Vector Normal Ray Bound)