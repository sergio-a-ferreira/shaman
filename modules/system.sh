# system.sh
# =============================================================================
#  ___   / _|   ___   _ __   _ __     ___  | |_
# / __| | |_   / _ \ | '__| | '_ \   / _ \ | __|
# \__ \ |  _| |  __/ | |    | | | | |  __/ | |_
# |___/ |_|    \___| |_|    |_| |_|  \___|  \__|
#
# Name       : system.sh
# Version    : v0.1
# Description: system (HW + O.S.) information
# Arguments  : N/A
# Returns    : N/A
# Requires   : lshw; lsb_release; uname; hostname;
# Notes      : N/A
#
# =============================================================================
# - Functions: ----------------------------------------------------------------
getHWInfo(){

	# Description: returns hardware information
	# Arguments  : N/A
	# Returns    : blob with file info
	# Notes      : see lshw options
	#				-html
	#				-json

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	sudo lshw 
}

# -----------------------------------------------------------------------------
getArch(){

	# Description: returns system architure
	# Arguments  : N/A
	# Returns    : string with system architure
	# Notes      : N/A

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	uname -m
}

# -----------------------------------------------------------------------------
getHostName(){

	# Description: returns the host name
	# Arguments  : N/A
	# Returns    : string with hostname
	# Notes      : N/A

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	hostname
}

# -----------------------------------------------------------------------------
getOS(){

	# Description: returns the OS type
	# Arguments  : N/A
	# Returns    : string with OS type
	# Notes      : N/A

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	uname -o
}

# -----------------------------------------------------------------------------
getDistroName(){

	# Description: returns the distro name (ID)
	# Arguments  : N/A
	# Returns    : string with distribution identifier
	# Notes      : N/A

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	lsb_release -i | cut -f2
}

# -----------------------------------------------------------------------------
getDistroType(){

	# Description: returns the base distro type
	# Arguments  : N/A
	# Returns    : string with distribution identifier
	# Notes      : N/A

	typeset base_distro

	case $(getDistroName) in 
		"EndeavourOS")
			base_distro="arch"
		;;
		*)
			base_distro="N/A"
		;;
	esac

	printf "${base_distro}\n"
}

# -----------------------------------------------------------------------------
getKernel(){

	# Description: returns the kernel name
	# Arguments  : N/A
	# Returns    : string with kernel name
	# Notes      : N/A

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	uname -r
}

# -----------------------------------------------------------------------------
getKernelVersion(){

	# Description: returns the kernel version
	# Arguments  : N/A
	# Returns    : string with kernel version
	# Notes      : N/A

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	uname -v
}

