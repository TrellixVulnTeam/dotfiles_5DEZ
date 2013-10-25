#!/bin/bash
#############################################################
# Author: Amila Perera
# File Name: zutil.zsh
#############################################################

# defining bash true/false
bash_true=0
bash_false=1

# regular colors
bash_red_color="\033[0;31m"
bash_green_color="\033[0;32m"
bash_yellow_color="\033[0;33m"
bash_blue_color="\033[0;34m"

bash_bold_red_color="\033[1;31m"
bash_bold_green_color="\033[1;32m"
bash_bold_yellow_color="\033[1;33m"
bash_bold_blue_color="\033[1;34m"

bash_reset_color="\033[0m"

##################################################################
## echo in red color
##################################################################
_echo_red()
{
	echo -e $bash_red_color"$@"$bash_reset_color
}

##################################################################
## echo in green color
##################################################################
_echo_green()
{
	echo -e $bash_green_color"$@"$bash_reset_color
}

##################################################################
## echo in yellow color
##################################################################
_echo_yellow()
{
	echo -e $bash_yellow_color"$@"$bash_reset_color
}

##################################################################
## echo in blue color
##################################################################
_echo_blue()
{
	echo -e $bash_blue_color"$@"$bash_reset_color
}

##################################################################
## outputs console log
##################################################################
_console_log()
{
	echo '['$(date +'%a %Y-%m-%d %H:%M:%S %z')']' $1
}

##################################################################
## prompts the user for confirmation and returns 'y'/'n'
##################################################################
_confirm()
{
	local answer=''
	local choice=''

	local prompt="confirm [y/n] > "

	until [[ "$choice" = "y" || "$choice" = "n" ]]; do

		read -q "answer?$prompt"
		case "$answer" in
			[yY] ) choice='y';;
			[nN] ) choice='n';;
			* ) ;;
		esac
	done

	[ "$choice" = "y" ] && return $bash_true || return $bash_false
}

##################################################################
## checks if the current shell is interactive
##################################################################
_check_for_shell_interactivity()
{
	case "$-" in
		*i* ) return $bash_true;;
		* ) return $bash_false;;
	esac
}

##################################################################
## checks if command exists
##################################################################
_check_if_command_exists()
{
	if [ $# -ne 1 ]; then
		echo "_check_if_command_exists function should take exactly one argument"
		return $bash_false
	fi

	type -P $1 >/dev/null
}
