#!/bin/bash

# gdb installation manual very clearly says that it relies on a POSIX
# compliant shell to do the building and installtion. It very specifically
# mentions that zsh will not work with the installation.
# Therefore this particular script is run using bash (look at the shebang!!!)


# utilities
source .common.sh

########################################
# main
########################################

# Parse gdb version
if [[ -z ${1} ]]; then
    echo "install_gdb.sh <VERSION>"
    die "No gdb version supplied"
fi

version=${1}

# OS infomation probing
probe_os_info

# Install pre-requisites
install_packages pre_requisites

# Working directory
cwd=${HOME}/work

# Project directory
project_directory=${cwd}/binutils-gdb

# Prepare build directory
build_dir=${project_directory}/build

# If project_directory doesn't exist create it and clone the project.
# Otherwise this script assumes that the project has already been cloned.
if [[ ! -e ${project_directory} ]]; then
    # Clone the repository
    mkdir -p ${cwd}
    cd ${cwd} && git clone https://github.com/bminor/binutils-gdb
    die_if_error $? "Cloning binutils-gdb failed"
else
    cd ${project_directory} && git co master && git clean -dfx
    # Fresh build each time!!!!
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
    branch="gdb-${version}-release"
fi

cd ${project_directory} && git checkout ${branch}
die_if_error $? "Checking out ${branch} failed"

mkdir -p "${build_dir}"
die_if_error $? "Creating the build directory failed"

# configure
cd ${build_dir} && ../configure --prefix=$HOME/.local/gdb-${version}

die_if_error $? "Configuration failed"

# make
cd ${build_dir} && make -j8
die_if_error $? "make failed"

# make install
cd ${build_dir} && make install -j8
die_if_error $? "make install failed"

# epilogue

echo
green "gdb-${version} installation successful"
echo
echo   "Bye..."

