#!/bin/bash

read -p 'Project Name: ' ProjectName
while [[ "${ProjectName}" == '' || "${ProjectName}" == *['!'@#\$%^\&*().+]* ]]; do
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
#include <iostream>
using namespace std;

int main() {
  cout<<"Hello World!"<<endl;
  return 0;
}
EOF
elif [[ "${cppFile}" == '' ]]; then
  touch ./${ProjectName}/src/main.cpp
  echo -e "\e[93mFile main.cpp  was created\e[0m"
#--- Add code simple
cat << 'EOF' > ./${ProjectName}/src/main.cpp
#include <iostream>
using namespace std;

int main() {
  cout<<"Hello World!"<<endl;
  return 0;
}
EOF
else
  touch ./${ProjectName}/src/${cppFile}.cpp
  echo -e "\e[93mFile ${cppFile}.cpp was created\e[0m"
#--- Add code simple
cat << 'EOF' > ./${ProjectName}/src/${cppFile}.cpp
#include <iostream>
using namespace std;

int main() {
  cout<<"Hello World!"<<endl;
  return 0;
}
EOF
fi

#--- CMake Project Name
read -p 'CMake project name: ' CMakeProjectName
while [[ "${CMakeProjectName}" == '' ]]; do
  read -p $'\e[91m!!CMake Project Name:\e[0m ' CMakeProjectName
done
#--- Execute ouput file name
read -p 'CMake executable file name: ' CMakeExecuteName
while [[ "${CMakeExecuteName}" == '' ]]; do
  read -p $'\e[91m!!Execute file name:\e[0m ' CMakeExecuteName
done
#--- C++ Standard
read -p 'C++ Standard (Ex. 11, 14, 17 ,20): ' getCPPstd 
CPPstd=(11 14 17 20)
if ! [[ "${CPPstd[*]}" =~ "${getCPPstd}" ]] || [[ "${getCPPstd}" == '' ]]; then
  getCPPstd=11 
fi

#--- CMakeLists.txt
cat << EOF > ./${ProjectName}/CMakeLists.txt
cmake_minimum_required(VERSION 3.17 FATAL_ERROR)
project(${CMakeProjectName} C CXX)

set(CMAKE_CXX_STANDARD ${getCPPstd})
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -Wall")

set(EXECUTABLE_OUTPUT_PATH "\${CMAKE_SOURCE_DIR}/bin")

include_directories(include)
file(GLOB SOURCES "src/*.cpp")
add_executable(${CMakeExecuteName} "\${SOURCES}")
EOF

#--- Build script 
cat << 'EOF' > ./${ProjectName}/buildScript.sh
#!/bin/bash
cd ./build
if [[ -f CMakeCache.txt ]]; then
  rm -rf CMakeCache.txt && echo "CMakeCache file was deleted.!"
else
  echo "File not found.."
fi
cmake -G "MSYS Makefiles" ../
cd ../
EOF

#--- VSCode .vscode folders
#   c_cpp_properties.json
#   launch.json
#   tasks.json
GCC_VERSION=$(g++ --version | head -n 1 | awk '{print $7}')

mkdir ./${ProjectName}/.vscode
cat << EOF > ./${ProjectName}/.vscode/c_cpp_properties.json
{
  "env": {
    "myDefaultIncludePath": [
      "\${workspaceFolder}",
      "\${workspaceFolder}/include"
    ],
    "myCompilerPath": "C:/msys64/mingw64/bin/g++.exe"
  },
  "configurations": [
    {
      "name": "Win32",
      "includePath": [
        "\${workspaceFolder}/**",
        "\${myDefaultIncludePath}",
        "C:/msys64/mingw64/include",
        "C:/msys64/mingw64/include/c++/${GCC_VERSION}",
        "C:/msys64/mingw64/include/c++/${GCC_VERSION}/backward",
        "C:/msys64/mingw64/include/c++/${GCC_VERSION}/x86_64-w64-mingw32/bits",
        "C:/msys64/mingw64/include/c++/${GCC_VERSION}/x86_64-w64-mingw32/ext",
        "C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/${GCC_VERSION}/include",
        "C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/${GCC_VERSION}/include/ssp"
      ],
      "defines": [
        "_DEBUG",
        "UNICODE",
        "_UNICODE"
      ],
      "compilerPath": "\${myCompilerPath}",
      "cStandard": "c11",
      "cppStandard": "gnu++${getCPPstd}",
      "intelliSenseMode": "gcc-x64",
      "browse": {
        "path": [
          "\${workspaceFolder}",
          "C:/msys64/mingw64/lib",
          "C:/msys64/mingw64/x86_64-w64-mingw32"      
        ],
        "limitSymbolsToIncludedHeaders": true,
        "databaseFilename": ""
      }
    }
  ],
  "version": 4
}
EOF

cat << EOF > ./${ProjectName}/.vscode/launch.json
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "name": "(gdb) Launch",
      "type": "cppdbg",
      "request": "launch",
      "program": "\${workspaceFolder}/bin/${CMakeExecuteName}.exe",
      "args": [],
      "stopAtEntry": false,
      "cwd": "\${workspaceFolder}/build",
      "environment": [],
      "externalConsole": false,
      "MIMode": "gdb",
      "miDebuggerPath": "C:/msys64/mingw64/bin/gdb.exe",
      "setupCommands": [
        {
          "description": "Enable pretty-printing for gdb",
          "text": "-enable-pretty-printing",
          "ignoreFailures": true
        }
      ]
      //"preLaunchTask": "Make"
    }
  ]
}
EOF

cat << 'EOF' > ./${ProjectName}/.vscode/tasks.json
{
  "version": "2.0.0",
  "options": {
    "cwd": "${workspaceRoot}/build"
  },
  "tasks": [
    {
      "label": "Cmake",
      "type": "shell",
      "windows":{
        "command": "bash ../buildScript.sh"
      },
      "linux":{
        "command": "../buildScript.sh"
      },
      "problemMatcher": [
        "$gcc"
      ]
    },
    {
      "label": "Make",
      "type": "shell",
      "command": "make",
      "problemMatcher": [
        "$gcc"
      ]
    }
  ]
}
EOF

echo "-------------------------------"
tree ${ProjectName}
echo "-------------------------------"
