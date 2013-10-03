#!/bin/bash
#############################################################
# Author: Amila Perera
# File Name: .bash_prompt
#############################################################

NONE="\[\033[0m\]"    # unsets color to term's fg color

# regular colors
K="\[\033[0;30m\]"    # black
R="\[\033[0;31m\]"    # red
G="\[\033[0;32m\]"    # green
Y="\[\033[0;33m\]"    # yellow
B="\[\033[0;34m\]"    # blue
M="\[\033[0;35m\]"    # magenta
C="\[\033[0;36m\]"    # cyan
W="\[\033[0;37m\]"    # white

# emphasized (bolded) colors
EMK="\[\033[1;30m\]"
EMR="\[\033[1;31m\]"
EMG="\[\033[1;32m\]"
EMY="\[\033[1;33m\]"
EMB="\[\033[1;34m\]"
EMM="\[\033[1;35m\]"
EMC="\[\033[1;36m\]"
EMW="\[\033[1;37m\]"

# background colors
BGK="\[\033[40m\]"
BGR="\[\033[41m\]"
BGG="\[\033[42m\]"
BGY="\[\033[43m\]"
BGB="\[\033[44m\]"
BGM="\[\033[45m\]"
BGC="\[\033[46m\]"
BGW="\[\033[47m\]"

un= hn= tty_temp= cur_tty=

case $workinghost in
CYGWIN*		)	hn=$(hostname) ;;
*			)	hn=$(hostname -s);;
esac

if (($UID != 0)); then
## user name for normal user
	un=$(whoami)
else
## capitalize user name for root
	un=$(whoami | tr 'a-z' 'A-Z')
fi

tty_temp="$(tty)"
cur_tty="${tty_temp:5}"

git_prompt_file=/usr/share/git-core/contrib/completion/git-prompt.sh
[ -f $git_prompt_file ] && source $git_prompt_file

function __svn_ps1() {
	local s=
	if [[ -d ".svn" ]] ; then
		rev_num=$(svn info | sed -n -e '/^Revision: \([0-9]*\).*$/s//\1/p')
		echo " (svn: $rev_num)"
	fi
}
##################################################################
## prompt command function
## basically extracted from http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x869.html
## and slightly adjusted
##################################################################
function prompt_command() {
	GIT_PS1_SHOWDIRTYSTATE=true
	git_prompt=$(__git_ps1 " (git: %s)")
	svn_prompt=$(__svn_ps1)
	curr_dir=$(pwd)
}

PROMPT_COMMAND=prompt_command

case $TERM in
xterm*|rxvt*	)	TITLEBAR='\[\033]0;\u@\h:\w\007\]' ;;
*				)	TITLEBAR="" ;;
esac

if (($UID != 0)); then
	## prompt for normal user
	PS1="$TITLEBAR\
${EMW}\342\224\214\342\224\200\342\224\200${EMW}(${EMM}\$un${EMC}@${EMM}\$hn${EMC}:${EMY}\$curr_dir${EMW})\
${EMW}\342\224\200${EMW}(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)${EMW})\
${EMR}\${git_prompt}\${svn_prompt}\n\
${EMW}\342\224\224\342\224\200\342\224\200${EMW}(${EMM}\#${EMW})${NONE} ${EMW}\\$ ${NONE}"
else
	## prompt for root
	PS1="$TITLEBAR\
${EMW}\342\224\214\342\224\200\342\224\200${EMW}(${EMR}\$un${EMC}@${EMM}\$hn${EMC}:${EMY}\$curr_dir${EMW})\
${EMW}\342\224\200${EMW}(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)${EMW})\
${EMR}\${git_prompt}\${svn_prompt}\n\
${EMW}\342\224\224\342\224\200\342\224\200${EMW}(${EMM}\#${EMW})${NONE} ${EMW}\\$ ${NONE}"
fi

PS2="${EMK}-${EMB}-${EMK}Continue${EMB}:${NONE} "
PS3=$(echo -e -n "\033[1;34m-\033[1;30m-Enter Your Option\033[1;34m:\033[0m ")
PS4="+xtrace $0[$LINENO]: "

export MYSQL_PS1="\u@\h [\d] > "

unset NONE K R G Y B M C W EMK EMR EMG EMY EMB EMM EMC EMW BGK BGR BGG BGY BGB BGM BGC BGW