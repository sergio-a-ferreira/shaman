#! /usr/bin/env bash
# =============================================================================
#  ___   / _|   ___   _ __   _ __     ___  | |_ 
# / __| | |_   / _ \ | '__| | '_ \   / _ \ | __|
# \__ \ |  _| |  __/ | |    | | | | |  __/ | |_ 
# |___/ |_|    \___| |_|    |_| |_|  \___|  \__|
# 
# Name        : cloud_fs.sh
# Version     : v0.1
# Description : manages cloud drive filesystems
# Arguments   : N/A
# Input Files : N/A
# Output Files: N/A
# Returns     : N/A
# Requires    : rclone; notify-send; meocloud
# Notes       : must wait until NetworkManager service starts
#				see https://rclone.org/
#				meocloud runs as a service
#				wget https://meocloud.pt/binaries/linux/x86_64/meocloud-latest_x86_64_beta.tar.gz
#
# =============================================================================
# - Source---------------------------------------------------------------------
[ -f ~/shaman/shaman.sh ] && source ~/shaman/shaman.sh

# - Functions: ----------------------------------------------------------------
# -----------------------------------------------------------------------------
main(){

	# Description: runtime entry point
	# Arguments  : parses script's ${0} ${@}
	# Returns    : 
	#	sucess   : 0
	#	error    : parses last error received

	typeset start_time=$( date +"%Y-%m-%d %T.%N" )
	typeset -i rc=0
	typeset drive
	typeset basedir=~/drives

	for drive in $(listDrives); do

		rc=0
		mountpoint=${basedir}/${drive//:}
		printf "checking drive ${drive}/ on mountpoint ${mountpoint}\n"

		getDriveStatus "${drive}" && continue
		
		dirExists "${mountpoint}"
		rc=$?
		
		if [ ${rc} -eq 0 ]; then
			printf "directory ${mountpoint} already exists\n"
		elif [ ${rc} -eq 127 ]; then
			printf "creating directory ${mountpoint}\n"
			makeDir "${mountpoint}"
			rc=$?
		else
			printf "unexpected error; skipping directory ${mountpoint}\n"
		fi

		if [ ${rc} -eq 0 ]; then
			printf "changing permissions for directory ${mountpoint}\n"
			changeMode "${mountpoint}" "755"
			rc=$?
			[ ${rc} -ne 0 ] && 
				printf "unexpected error; could not change permissions for directory ${mountpoint}\n"
		fi 

		if [ ${rc} -eq 0 ]; then
			printf "mounting drive ${drive}/ in mountpoint ${mountpoint}\n"
			mountDrive "${drive}/" "${mountpoint}"
			rc=$?
			[ ${rc} -ne 0 ] && 
				printf "unexpected error; could not mount drive ${drive} in directory ${mountpoint}\n"
		fi
	done

	# start meocloud
	meocloud status || meocloud start

	typeset end_time=$(date +"%Y-%m-%d %T.%N")
	return ${rc}
}

# =============================================================================
# - Main : --------------------------------------------------------------------
# evaluate if script is to be sourced or executed
if [ "${0}" != "bash" ]; then
	# run script
	main "${@}"
else
	# source file; if needed unset variables and functions
	unset main
	#echo "Warning: this script is not aimed to be sourced!!" 1>&2
	#echo "Please run:    sh install.sh" 1>&2
fi

