#!/bin/bash
#############################################################
# Author: Amila Perera
# File Name: .bashrc
#
# Description:
# bash initialization file
# source configuration files from $HOME/.bash directory
#############################################################

# source the utility functions
source "$HOME/.bash/.bash_utility"

dir_path=${HOME}/.bash

config_file_list="bash_env bash_colors bash_prompt bash_alias bash_func bash_fbm bash_comp"

for file in ${config_file_list}; do
	abs_file_path=${dir_path}/.${file}
	[ -f ${abs_file_path} ] && source ${abs_file_path}
done

unset dir_path config_file_list
