#! /usr/bin/env bash
# =============================================================================
#  ___   / _|   ___   _ __   _ __     ___  | |_ 
# / __| | |_   / _ \ | '__| | '_ \   / _ \ | __|
# \__ \ |  _| |  __/ | |    | | | | |  __/ | |_ 
# |___/ |_|    \___| |_|    |_| |_|  \___|  \__|
# 
# Name       : bash_template.sh
# Version    : v0.0
# Description: bash script template
# Arguments  : describe arguments here
# Returns    : describe expected return and possible errors
# Notes      : additional notes like dependencies, bugs, todo's and fixes
#
# =============================================================================
# - Functions: ----------------------------------------------------------------
setArguments(){

	# Description: creates script and function options / arguments
	# Arguments  : 
	#       -1: script [${0}] or function name [${FUNCNAME}]
	#       -2: arguments received
	# Returns    :
	#       -0: success
	#       -1: unrecognized option
	#       -2: internal error
	# Notes
	#       - arg   option / flag
	#       - arg:  mandatory argument
	#       - arg:: optional argument


	typeset process="${0}"
	typeset arglist="${@}"

	options=$(getopt -o 'hvc:V::' -a --long help,version,config:,verbose:: -n ${process} -- "${arglist}")
	
	if [ ${?} -ne 0 ]; then
		exit 1
	fi

	eval set -- "${options}"
	unset options

	while true; do

		case "${1}" in

			'-h' | '--help')
				sed -n '2,/# =/ p' ${process} | sed 's|^#\ ||' 1>&2
				exit 0
			;;
			'-v' | '--version')
				typeset version=$(grep "^# Version" ${0} | sed 's|^.*:\ ||')
				echo "${0} ${version}" 1>&2
				exit 0
			;;
			'-c' | '--config')
				echo "Path to config file:  ${2}"
				shift 2
				continue
			;;
			'-V' | '--verbose')
				case "${2}" in
					'')
					verbose=1
					;;
					*)
					verbose=${2}
					;;
				esac
				echo "verbose: ${verbose}"
				shift 2
				continue
			;;
			'--')
				shift
				echo "remaining args '$@'"
				break
			;;
			*)
				echo "${0}: internal error!" 1>&2
				exit 2
			;;
		esac
	done
}


# -----------------------------------------------------------------------------
main(){

	# Description: runtime entry point
	# Arguments  : parses script's ${0} ${@}
	# Returns    : 
	#	sucess   : 0
	#	error    : parses last error received
	# Notes      : this function is an auxiliary entry point:
	#                sets process control variables;
	#                sources scripts and libaries;
	#                orchestrates the process flow.

	# process start timestamp
	typeset start_time=$( date +"%Y-%m-%d %T.%N" )
	# script call full path
	typeset execpath="${0}"
	# script basename
	typeset script="${execpath##*/}"
	# process PID
	typeset -i pid=$$
	# process argument values
	typeset arg_v="${@}"
	# process argument count
	typeset -i arg_c=${#@}

	typeset func_name="${FUNCNAME}"
	typeset -i rc=0

	# source libs and scripts
	setArguments ${arg_v}	# TODO: put into a lib

	# do something (execute a script or binary)
	# ... and get it's return code
	echo doing something; sleep 2
	rc=${?}

	typeset end_time=$( date +"%Y-%m-%d %T.%N" )
	
	# debug info
	echo "start   : ${start_time}"
	echo "execpath: ${execpath}"
	echo "script  : ${script}"
	echo "pid     : ${pid}"
	echo "arg_v   : ${arg_v}"
	echo "arg_c   : ${arg_c}"
	echo "function: ${func_name}"
	echo "end     : ${end_time}"

	return ${rc}
}


# =============================================================================
# - Main : --------------------------------------------------------------------
# evaluate if script is to be sourced or executed
if [ "${0}" = "bash" ]; then
	# run script
	main "${@}"
else
	# source file; if needed unset variables and functions here
	# if unsourcing main clears calling main --> WA call main functions the scriptname
	unset main	
fi


