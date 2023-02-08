# core_fn.sh
# =============================================================================
#  ___   / _|   ___   _ __   _ __     ___  | |_
# / __| | |_   / _ \ | '__| | '_ \   / _ \ | __|
# \__ \ |  _| |  __/ | |    | | | | |  __/ | |_
# |___/ |_|    \___| |_|    |_| |_|  \___|  \__|
#
# Name       : core_fn.sh
# Version    : v0.1
# Description: shaman core functions
# Arguments  : N/A
# Returns    : N/A
# Requires   : N/A
# Notes      : N/A
#
# =============================================================================
# - Functions: ----------------------------------------------------------------
now() {

	# Description: returns the current timestamp
	# Arguments  : N/A
	# Returns    : date formatted year to nanosecond
	#				example: 2022-08-08 00:43:31.557153551
	# Notes      : N/A

	date +"%Y-%m-%d %T.%N"
}

# -----------------------------------------------------------------------------
start() {

	# Description: starts the process
	# Arguments  : N/A
	# Returns    : N/A
	# Notes      : N/A

	# process start timestamp
	typeset start_time=$(now)

	# script call full path
	typeset execpath="${0}"
	# script basename
	typeset script="${execpath##*/}"

	# process argument values
	typeset -a arg_v="${@}"
	# process argument count
	typeset -i arg_c=${#@}

	# process PID
	typeset -i pid=$$
}

# -----------------------------------------------------------------------------
die(){

	# Description: exits the program with a formated error message to STDERR
	# Arguments  : 
	#		- an integer with a return / exit code
	# 		- a string with additional information (optional)
	# Returns    : exits program when called
	# Notes      : N/A

	typeset -i rc=${1}; shift
	typeset end_time=$(now)

	typeset message
	typeset message_aux="${@}"

	if [ ${rc} -eq 0 ]; then
		message="${script} [${end_time}]: END OK"
	else
		message="\t"
		case ${rc} in
			128) message+="missing argument:\tproject_name";;
			129) message+="missing dependencies:\t${message_aux}";;
			130) message+="could not create directory / file '${message_aux}'";;
			*)   message+="no error message defined";;
		esac
		message+="\n${script} [${end_time}]: END ERROR ${rc}\n"
	fi

	_print "${message}\n"
	exit ${rc}
}

# -----------------------------------------------------------------------------
print() {

	# Description: prints a formated message to STDOUT
	# Arguments  : the message to print
	# Returns    : success; 
	# Notes
	#       N/A

	typeset message="$@"
	printf "${message}\n"
}

# -----------------------------------------------------------------------------
debug() {

	# Description: auxiliary function to debug the program
	# Arguments  : 
	#			- calling function
	#			- auxiliary message
	#			- a list of variable names to check / print
	# Returns    :
	# Notes
	#       N/A

	typeset func_name="${FUNCNAME}"
	typeset -i rc=0
	typeset caller=${1}; shift
	typeset message=${1}; shift
	typeset -a variables="$@"

	_print " # ${script}::$caller"
	_print " # \t${message}"
	for variable in ${variables[@]}; do
		printf " # \t\t"
		eval _print "${variable}: \$${variable}"
	done

	return ${rc}
}
