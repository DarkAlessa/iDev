#!/bin/bash

read -p 'Project Name: ' ProjectName
while [[ "${ProjectName}" == '' || "${ProjectName}" == *['!'@#\$%^\&*().+]* ]]
do
    read -p $'\e[91mProject name [a-z][A-Z[0-9]! :\e[0m ' ProjectName
done
    mkdir -p ./${ProjectName}/src ./${ProjectName}/include ./${ProjectName}/build ./${ProjectName}/bin
    echo -e "\e[93mProject ${ProjectName} was created\e[0m"

#--- Create source file
read -p 'Make source file (Ex. main.cpp) : ' cppFile
if [[ "${cppFile}" == *.cpp ]]; then 
    touch ./${ProjectName}/src/${cppFile}
    echo -e "\e[93mFile ${cppFile} was created\e[0m"
#--- Add code simple
cat << 'EOF' > ./${ProjectName}/src/${cppFile}
#include <gtkmm/application.h>
#include <iostream>
using namespace std;

int main(int argc, char *argv[]) {

    return 0;
}
EOF
elif [[ "${cppFile}" == '' ]]; then
    touch ./${ProjectName}/src/main.cpp
    echo -e "\e[93mFile main.cpp  was created\e[0m"
#--- Add code simple
cat << 'EOF' > ./${ProjectName}/src/main.cpp
#include <gtkmm/application.h>
#include <iostream>
using namespace std;

int main(int argc, char *argv[]) {

    return 0;
}
EOF
else
    touch ./${ProjectName}/src/${cppFile}.cpp
    echo -e "\e[93mFile ${cppFile}.cpp was created\e[0m"
#--- Add code simple
cat << 'EOF' > ./${ProjectName}/src/${cppFile}.cpp
#include <gtkmm/application.h>
#include <iostream>
using namespace std;

int main(int argc, char *argv[]) {

    return 0;
}
EOF
fi

#--- CMake Project Name
read -p 'CMake project name: ' CMakeProjectName
while [[ "${CMakeProjectName}" == '' ]]
do
    read -p $'\e[91m!!CMake Project Name:\e[0m ' CMakeProjectName
done
#--- Execute ouput file name
read -p 'CMake executable file name: ' CMakeExecuteName
while [[ "${CMakeExecuteName}" == '' ]]
do
    read -p $'\e[91m!!Execute file name:\e[0m ' CMakeExecuteName
done
#--- C++ Standard
read -p 'C++ Standard (Ex. 11, 14, 17 ,20): ' getCPPstd 
CPPstd=(11 14 17 20)
if ! [[ "${CPPstd[*]}" =~ "${getCPPstd}" ]] || [[ "${getCPPstd}" == '' ]]
then
    getCPPstd=11 
fi

#--- CMakeLists.txt
cat << EOF > ./${ProjectName}/CMakeLists.txt
CMAKE_MINIMUM_REQUIRED(VERSION 3.17 FATAL_ERROR)
PROJECT(${CMakeProjectName} C CXX)

SET(CMAKE_CXX_STANDARD ${getCPPstd})
SET(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_CXX_EXTENSIONS OFF)
SET(CMAKE_BUILD_TYPE Debug)
SET(CMAKE_BUILD_TYPE Release)

SET(EXECUTABLE_OUTPUT_PATH "\${CMAKE_SOURCE_DIR}/bin")

# Use the package PkgConfig to detect GTKmm headers/library files
FIND_PACKAGE(PkgConfig REQUIRED)
PKG_CHECK_MODULES(GTKMM REQUIRED gtkmm-3.0)

# Setup CMake to use GTKmm, tell the compiler to look for headers
INCLUDE_DIRECTORIES(\${GTKMM_INCLUDE_DIRS} include)

# Linker where to look for libraries
LINK_DIRECTORIES(\${GTKMM_LIBRARY_DIRS})

# Source files
FILE(GLOB SOURCES "src/*.cpp")

# Add other flags to the compiler
ADD_DEFINITIONS(\${GTKMM_CFLAGS_OTHER})

# Add an executable compiled from source file
ADD_EXECUTABLE(${CMakeExecuteName} \${SOURCES})

# Link the target to the GTKmm libraries
TARGET_LINK_LIBRARIES(${CMakeExecuteName} \${GTKMM_LIBRARIES})
EOF

#--- Build script 
cat << 'EOF' > ./${ProjectName}/buildScript.sh
#!/bin/bash
##
cd ./build
if [[ -f CMakeCache.txt ]]
then
    rm -rf CMakeCache.txt && echo "CMakeCache file was deleted.!"
else
    echo "File not found.."
fi
##
cmake -G "MSYS Makefiles" ../
cd ../
EOF

echo "-------------------------------"
tree ${ProjectName}
echo "-------------------------------"
