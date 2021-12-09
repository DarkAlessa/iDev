#!/bin/bash

cd ./build
if [ -f CMakeCache.txt ]
then
	rm -rf CMakeCache.txt && echo "CMakeCache file was deleted.!"
else 
	echo "File not found.."
fi

cmake -G "MSYS Makefiles" ../
cd ../
