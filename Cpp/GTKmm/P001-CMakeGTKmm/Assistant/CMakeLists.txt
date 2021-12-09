CMAKE_MINIMUM_REQUIRED(VERSION 3.15)
PROJECT(gtkmm CXX)

SET(CMAKE_CXX_STANDARD 17)
SET(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_CXX_EXTENSIONS OFF)
SET(CMAKE_BUILD_TYPE Debug)
SET(CMAKE_BUILD_TYPE Release)

# Use the package PkgConfig to detect GTK+ headers/library files
FIND_PACKAGE(PkgConfig REQUIRED)
PKG_CHECK_MODULES(GTKMM REQUIRED gtkmm-3.0)

FILE(GLOB SOURCES "src/*.cpp")

# Setup CMake to use GTK+, tell the compiler where to look for headers
# and to the linker where to look for libraries
INCLUDE_DIRECTORIES(${GTKMM_INCLUDE_DIRS} header)
LINK_DIRECTORIES(${GTKMM_LIBRARY_DIRS})

# Add other flags to the compiler
ADD_DEFINITIONS(${GTKMM_CFLAGS_OTHER})

# Add an executable compiled from hello.cpp
ADD_EXECUTABLE(assistant ${SOURCES})

# Link the target to the GTK+ libraries
TARGET_LINK_LIBRARIES(assistant ${GTKMM_LIBRARIES})
