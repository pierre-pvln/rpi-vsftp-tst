#!/bin/bash

# set excecute mode for shell scripts 
chmod +x *.sh

# reads and executes commands from filename in the current shell environment
source set_bld.sh

# use environment variables during build
docker build --tag $my_build_name ../
