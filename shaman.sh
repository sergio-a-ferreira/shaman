# shaman.sh
# =============================================================================
#  ___   / _|   ___   _ __   _ __     ___  | |_
# / __| | |_   / _ \ | '__| | '_ \   / _ \ | __|
# \__ \ |  _| |  __/ | |    | | | | |  __/ | |_
# |___/ |_|    \___| |_|    |_| |_|  \___|  \__|
#
# Name       : shaman.sh
# Version    : v0.0
# Description: shaman process orchestrator
# Arguments  : N/A
# Returns    :
# Notes      :
#
# =============================================================================
# - Main : --------------------------------------------------------------------
# evaluate if shaman is already loaded
if [ -z "${SHAMAN_ENV}" ]; then

	# set core directories
	export SHAMAN_PATH=~/shaman
	#export SHAMAN_PATH=/opt/shaman

	typeset -A SHAMAN_DIRS=(
		[MODULES]=${SHAMAN_PATH}/modules
		[SCRIPTS]=${SHAMAN_PATH}/scripts
		[CONFIG]=${SHAMAN_PATH}/config
		[LOGS]=${SHAMAN_PATH}/logs
		[DOCS]=${SHAMAN_PATH}/docs
	)
	export SHAMAN_DIRS
	
	# import / load  modules
	if [ -d ${SHAMAN_DIRS[MODULES]} ]; then 
		for module in $(ls ${SHAMAN_DIRS[MODULES]}/*.sh); do
			. ${module}
		done
	else
		printf "fatal error: could not source modules directory: ${SHAMAN_DIRS[MODULES]}n" >&2
		return 128
	fi

	# shaman successfully loaded
	export SHAMAN_ENV="on"
fi

