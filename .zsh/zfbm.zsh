#############################################################
# Author: Amila Perera
# File Name: zfbm.zsh
#############################################################

_fbm_usage()
{
	printf "Usage: fbm: fbm [option] [bookmarkname]\nType fbm -h for help\n" 1>&2
}

_fbm_help()
{
	cat <<- HELPMSG
			fbm: Folder BookMark Utility
			Usage: fbm [OPTION] [BOOKMARK] [DIRECTORY]

			fbm BOOKMARK                     Jumps to the directory given by BOOKMARK
			Options:
			  -c BOOKMARK [DIRECTORY]        Creates a bookmark.
			                                 If no directory is given the current directory is bookmarked
			  -d BOOKMARK1 BOOKMARK2...      Delete bookmarks
			  -r BOOKMARK_OLD BOOKMARK_NEW   Renames a bookmark
			  -m BOOKMARK DIRECTORY          Modifies directory for a given bookmark
			  -e BOOKMARK1 BOOKMARK2...      Export bookmarks as variables
			                                 After exporting variables you can use \$BOOKMARK instead of the directory name
			  -l                             Lists bookmarks(same operation is performed if fbm is executed with no option)
			  -h                             Displays this help
	HELPMSG
}

_check_if_bm_exists()
{
	local bmexist= name="${1}" bmfile="${2}"
	[ ! -f "${bmfile}" ] && return 0		# returns false since bookmark file doesn't exist

	# check if book mark exists in particular bookmark file
	bmexist=$(awk -F':' '$1 == "'${name}'" { print $1 }' ${bmfile})
	[ ! -z $bmexist ] && { return 1; } || { return 0; }
}

_fbm_gotobm()
{
	local name=${1} bmfile=${2} dirname=

	_check_if_bm_exists $name $bmfile
	(($? == 0)) && { printf "fbm: bookmark doesn't exist\n" 1>&2; return 1; }

	dirname=$(awk -F':' '$1 == "'${name}'" { print $2 }' ${bmfile})

	[ ! -d "${dirname}" ] && { printf "fbm: directory doesn't exist\n" 1>&2; return 1; }

	cd "${dirname}"
	return 0
}

_fbm_list()
{
	if [ -f "${1}" ]; then
		sed 's/:/\t/' ${1} | sort | \
		{
		while read rbm rdir
		do
			[ -d "$rdir" ] && printf "%-20s ---> %s\n" "$rbm" "$rdir" \
						   || printf "%-20s ---> %s <====> [%s]\n" "$rbm" "$rdir" "doesn't exist"
		done
		}
	else
		printf "No bookmarks are entered\n" 1>&2 && _fbm_usage
	fi
}

_fbm_checkvar()
{
	local result=$(export -p | grep -c "${1}=")
	echo $result
}

##################################################################
##fbm()
##folder bookmark function
##################################################################
fbm()
{
	local bm= dir= file="${HOME}/.fbookmarks"

	case $1 in
	-c)
		shift
		[ $# -gt 2 -o $# -eq 0 ] && { _fbm_usage; return 101; }
		bm=$1
		if [ -z "${2}" ]; then
			dir="${PWD}"
		else
			[[ "${2}" =~ ^~ || "${2}" =~ ^\/[^\/]* ]] && dir="${2}" || dir="$PWD/${2}"
		fi
		_check_if_bm_exists $bm $file
		[ $? -eq 1 ] && { printf "fbm: bookmark name already exists\n" 1>&2; return 102; }
		dir=$(echo "${dir}/" | sed 's/\/\/*$/\//')	# appending a / at the end of directory whether user supplies one or not
		[ ! -d "${dir}" ] \
			&& printf "fbm: directory doesn't exist\n" 1>&2 \
			|| printf "%s:%s\n" "$bm" "$dir" >> $file
		;;

	-d)
		shift
		for bm in "$@"; do
			_check_if_bm_exists $bm $file
			if [ $? -eq 1 ]; then
				local tempfile="${file}"".tmp"
				sed "/$bm:/d" $file > $tempfile; mv -f $tempfile $file
			else
				printf "fbm: bookmark doesn't exist : %s\n" "$bm"
			fi
		done
		;;

	-r)
		shift
		[ $# -ne 2 ] && { _fbm_usage; return 101; }
		local oldbm=${1} newbm=${2}
		_check_if_bm_exists $oldbm $file
		if [ $? -eq 1 ]; then
			local tempfile="${file}"".tmp"
			sed "s/$oldbm:/$newbm:/" $file > $tempfile; mv -f $tempfile $file
		else
			printf "fbm: bookmark doesn't exist : %s\n" "$oldbm"
		fi
		;;

	-m)
		shift
		[ $# -gt 2 -o $# -eq 0 ] && { _fbm_usage; return 101; }
		bm=$1
		if [ -z "${2}" ]; then
			dir="${PWD}"
		else
			[[ "${2}" =~ ^~ || "${2}" =~ ^\/[^\/]* ]] && dir="${2}" || dir="$PWD/${2}"
		fi
		_check_if_bm_exists $bm $file
		if [ $? -eq 1 ]; then
			[ ! -d "${dir}" ] && { printf "fbm: directory doesn't exists\n" 1>&2; return 101; }
			dir=$(echo "${dir}/" | sed 's/\/\/*$/\//')	# appending a / at the end of directory whether user supplies one or not
			local tempfile="${file}"".tmp"
				sed "/$bm:/d" $file > $tempfile
				printf "%s:%s\n" "$bm" "$dir" >> $tempfile
				mv -f $tempfile $file
		else
			printf "fbm: bookmark doesn't exist : %s\n" "$bm"
		fi
		;;

	-e)
		shift
		for bm in "$@"; do
			local existVar=$(_fbm_checkvar $bm)
			(($existVar > 0)) && { printf "fbm: environment variable already exists\n" 1>&2; return 1; }
			_check_if_bm_exists $bm $file
			if [ $? -eq 1 ]; then
				local dirname=$(awk -F':' '$1 == "'$bm'" { print $2 }' $file)
				[ ! -d $dirname ] && { printf "fbm: directory doesn't exist\n" 1>&2; return 1; }
				export $bm=$dirname
			else
				printf "fbm: bookmark doesn't exist : %s\n" "$bm"
			fi
		done
		;;

	-l)
		shift
		_fbm_list "$file"
		;;

	-h)
		_fbm_help ;;

	*)
		if [ $# -eq 0 ]; then
			_fbm_list "$file"
		elif [ $# -gt 1 ]; then
			_fbm_usage; return 1;
		else
			_fbm_gotobm $1 $file
			[ $? -ne 0 ] && { _fbm_usage; return 1; };
			return 0
		fi
		;;
	esac

	return $?
}
