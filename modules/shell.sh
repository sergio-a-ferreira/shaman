# shell.sh
# =============================================================================
#  ___   / _|   ___   _ __   _ __     ___  | |_
# / __| | |_   / _ \ | '__| | '_ \   / _ \ | __|
# \__ \ |  _| |  __/ | |    | | | | |  __/ | |_
# |___/ |_|    \___| |_|    |_| |_|  \___|  \__|
#
# Name       : shell.sh
# Version    : v0.1
# Description: shell functions and environment settings
# Arguments  : N/A
# Returns    : N/A
# Requires   : chsh; basename; printf; readlink;
# Notes      : N/A
#
# =============================================================================
# - Functions: ----------------------------------------------------------------
getShell(){

	# Description: returns the current shell
	# Arguments  : N/A
	# Returns    : string with the shell 
	# Notes      : N/A

	typeset func_name="${FUNCNAME:=${.sh.fun}}"

	basename $(readlink /proc/$$/exe)
}

# -----------------------------------------------------------------------------
getShellVersion(){

	# Description: returns the current shell's version
	# Arguments  : N/A
	# Returns    : string with the shell's version
	# Notes      : N/A

	typeset func_name="${FUNCNAME:=${.sh.fun}}"

	$(getShell) --version | head -1
}

# -----------------------------------------------------------------------------
getShellType(){

	# Description: returns the current shell type
	# Arguments  : N/A
	# Returns    : string with the shell  type
	#              I(nteractive); L(ogin); B(oth); N(one);
	# Notes      : XXX validar a login shell

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset -i aux=0

	# evaluate if is interactive
	printf "$-" | grep -q i && ((aux+=1))

	# evaluate if is login
	if [ "${SHELL}" = "ksh" ]; then
		typeset vars=$(set -o)
		[ $(printf "$vars" | grep login_shell | awk -F" " '{print($NF)}') = "on" ] &&
			((aux+=2))
	elif [ "${SHELL}" = "bash" ]; then
		[ $(shopt login_shell | cut -f2) = "on" ] && 
			((aux+=2))
	fi

	case ${aux} in
		0) printf "N\n";;		
		1) printf "I\n";;		
		2) printf "L\n";;		
		3) printf "B\n";;		
	esac
}

# -----------------------------------------------------------------------------
listShells(){

	# Description: lists available shells
	# Arguments  : N/A
	# Returns    : list with the available shells
	# Notes      : N/A

	typeset func_name="${FUNCNAME:=${.sh.fun}}"

	chsh -l
}

# -----------------------------------------------------------------------------
setShell(){

	# Description: changes the user's default shell
	# Arguments  : the full pathname of any of shells listed in the /etc/shells file
	# Returns    : 0 if operation was successful; 1 on error
	# Notes      : run listShells to get a list of available shells

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset shell=${1}

	if [ -z "${shell}" ]; then
		printf "error ${func_name}: missing argument\n" 1>&2
		return 1
	fi

	typeset -a shells=$(listShells)
	case ${shells} in 
		*"${shell}"*)
			chsh -s ${shell}
		;;
		*)
			printf "error ${func_name}: shell ${shell} is not available\n" 1>&2
		;;
	esac
}

# =============================================================================
# - Settings: -----------------------------------------------------------------
# (re)set environment variables
export SHELL=$(getShell)
export SHELL_TYPE=$(getShellType)
