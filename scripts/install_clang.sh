#!/bin/bash

# utilities
source .common.sh

########################################
# main
########################################

# Parse clang version
if [[ -z ${1} ]]; then
  echo "install_clang.sh <VERSION>"
  die "No clang version supplied"
fi

version=${1}

# OS infomation probing
probe_os_info

# Install pre-requisites
install_packages pre_requisites

# Working directory
cwd=${HOME}/work

# Project directory
project_directory=${cwd}/llvm-project

# Prepare build directory
build_dir=${project_directory}/build

# If project_directory doesn't exist create it and clone the project.
# Otherwise this script assumes that the project has already been cloned.
if [[ ! -e ${project_directory} ]]; then
    # Clone the repository
    mkdir -p ${cwd}
      cd ${cwd} && git clone https://github.com/llvm/llvm-project.git
      die_if_error $? "Cloning llvm-project failed"
else
    # Fresh build each time!!!!
    cd ${project_directory} && git co master && git clean -dfx

    if [[ -d "${build_dir}" ]]; then
        rm -rf "${build_dir}"
    fi
    die_if_error $? "Removing the existing build directory failed"
fi

cd ${project_directory} && git pull
die_if_error $? "Pulling failed"

# Work out the branch with the version provided
branch='${version}'
if [[ "$version" != "master" ]]; then
    branch="llvmorg-${version}"
fi

cd ${project_directory} && git checkout ${branch}
die_if_error $? "Checking out ${branch} failed"

mkdir -p "${build_dir}"
die_if_error $? "Creating the build directory failed"

# Configure CMake
cd ${build_dir} && cmake -G "Ninja" \
                            -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lldb" \
                            -DCMAKE_INSTALL_PREFIX=${HOME}/.local/clang-${version} \
                            -DCMAKE_BUILD_TYPE=Release \
                            ../llvm
die_if_error $? "CMake configuration failed"

# make
cd ${build_dir} && ninja -j8
die_if_error $? "ninja build failed"

# make install
cd ${build_dir} && ninja install -j8
die_if_error $? "ninja install failed"

echo
green "clang-${version} installation successful"
echo
echo   "Bye..."

