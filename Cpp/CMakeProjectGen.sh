#!/bin/bash

read -p 'Project Name: ' ProjectName
while [[ $ProjectName == '' || $ProjectName == *['!'@#\$%^\&*()_+]* ]]
do
    read -p $'\e[91mProject name [a-z][A-Z[0-9]! :\e[0m ' ProjectName
done
    mkdir -p ./${ProjectName}/src ./${ProjectName}/include ./${ProjectName}/build ./${ProjectName}/bin
    echo -e "\e[93mProject ${ProjectName} was created\e[0m" 
#--- Create source file
read -p 'Make source file (Ex. main.cpp) : ' cppFile
if [[ $cppFile == *.cpp ]]
then 
    touch ./${ProjectName}/src/${cppFile}
    echo -e "\e[93mFile ${cppFile} was created\e[0m"
elif [[ $cppFile == '' ]]
then
    touch ./${ProjectName}/src/main.cpp
    echo -e "\e[93mFile main.cpp  was created\e[0m" 
#--- Header adn main() gen
    echo '#include <iostream>
using namespace std;
int main() {
    cout<<"Hello World!"<<endl;
    return 0;
}' >> ./${ProjectName}/src/main.cpp
else
    touch ./${ProjectName}/src/${cppFile}.cpp
    echo -e "\e[93mFile ${cppFile}.cpp was created\e[0m"
    #--- Header adn main() gen
    echo '#include <iostream>
using namespace std;
int main() {
    cout<<"Hello World!"<<endl;
    return 0;
}' >> ./${ProjectName}/src/${cppFile}.cpp
fi

#--- CMake Project Name
read -p 'CMake project name: ' CMakeProjectName
while [[ $CMakeProjectName == '' ]]
do
    read -p $'\e[91m!!CMake Project Name:\e[0m ' CMakeProjectName
done
#--- Execute ouput file name
read -p 'CMake executable file name: ' CMakeExecuteName
while [[ $CMakeExecuteName == '' ]]
do
    read -p $'\e[91m!!Execute file name:\e[0m ' CMakeExecuteName
done
#--- C++ Standard
read -p 'C++ Standard (Ex. 11, 14, 17 ,20): ' getCPPstd 
CPPstd=(11 14 17 20)
if ! [[ ${CPPstd[*]} =~ $getCPPstd ]] || [[ $getCPPstd == '' ]]
then
    getCPPstd=11 
fi

echo "cmake_minimum_required(VERSION 3.17 FATAL_ERROR)
project(${CMakeProjectName} C CXX)

set(CMAKE_CXX_STANDARD ${getCPPstd})
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_CXX_FLAGS \"\${CMAKE_CXX_FLAGS} -Wall\")

set(EXECUTABLE_OUTPUT_PATH \"\${CMAKE_SOURCE_DIR}/bin\")

include_directories(include)
file(GLOB SOURCES \"src/*.cpp\")
add_executable(${CMakeExecuteName} \"\${SOURCES}\")" >> ./${ProjectName}/CMakeLists.txt
#--- Build script 
echo '#!/bin/bash
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
cd ../' >> ./${ProjectName}/buildScript.sh
#
echo "-------------------------------"
tree ${ProjectName}
echo "-------------------------------"

