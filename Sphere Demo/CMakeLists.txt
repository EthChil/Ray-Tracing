cmake_minimum_required(VERSION 2.8.4)
project(SphereDemo)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE
        PointLight.cpp
        SphereObj.cpp
        Tracer.cpp)
set(HEADERS
        PointLight.hpp
        SphereObj.hpp
        Tracer.hpp)

add_executable(${PROJECT_NAME} main.cpp)

add_library(Tracer STATIC Tracer.cpp Tracer.hpp)
add_library(SphereObj STATIC SphereObj.cpp SphereObj.hpp)
add_library(PointLight STATIC PointLight.cpp PointLight.hpp)
add_library(PlaneObj PlaneObj.cpp PlaneObj.hpp)

target_link_libraries(${PROJECT_NAME} Tracer SphereObj PointLight PlaneObj)