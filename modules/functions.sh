# functions.sh
# =============================================================================
#  ___   / _|   ___   _ __   _ __     ___  | |_
# / __| | |_   / _ \ | '__| | '_ \   / _ \ | __|
# \__ \ |  _| |  __/ | |    | | | | |  __/ | |_
# |___/ |_|    \___| |_|    |_| |_|  \___|  \__|
#
# Name       : functions.sh
# Version    : v0.1
# Description: shaman functions
# Arguments  : N/A
# Returns    :
# Requires   : see shaman/requirements.txt
# Notes      :
#
# =============================================================================
# - Functions: ----------------------------------------------------------------
# -----------------------------------------------------------------------------
# ver iwconfig para determinar se a rede é wireless
# ip route show default para obter o IP do host de uma VM (via NAT)

getLANIP(){

	# Description: prints the LAN IP address
	# Arguments  : N/A
	# Returns    : string with IP
	# Notes      : 

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	ip addr show wlan0 | grep -w inet | awk -F" " '{printf("%s\n", $2)}'
}

# -----------------------------------------------------------------------------
getWANIP(){

	# Description: prints the WAN (public) IP address
	# Arguments  : N/A
	# Returns    : string with IP
	# Notes      : 

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	dig +short TXT CH whoami.cloudflare @1.0.0.1 | sed 's/"//g'
}

# -----------------------------------------------------------------------------
# user / group information and management
# -----------------------------------------------------------------------------
getUserName () {

	# Description: prints the user name
	# Arguments  : N/A
	# Returns    : string with username
	# Notes      : N/A

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	id -un
}

# -----------------------------------------------------------------------------
getUserUID () {

	# Description: prints the user UID
	# Arguments  : N/A
	# Returns    : string with user UID
	# Notes      : N/A

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	id -u
}

# -----------------------------------------------------------------------------
getUserGroup () {
	
	# Description: prints the user main group name
	# Arguments  : N/A
	# Returns    : string with user main group name
	# Notes      : N/A

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
 	id -gn
}

# -----------------------------------------------------------------------------
getUserGID () {

	# Description: prints the user GID
	# Arguments  : N/A
	# Returns    : string with user GID
	# Notes      : N/A	

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
 	id -g
}

# -----------------------------------------------------------------------------
getUserGroups () {

	# Description: prints the user group names
	# Arguments  : N/A
	# Returns    : list of the user group names
	# Notes      : N/A	

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
  	id -Gn
}

# -----------------------------------------------------------------------------
getUserGIDs () {

	# Description: prints the user GID's
	# Arguments  : N/A
	# Returns    : list of the user GID's
	# Notes      : N/A	

	# prints the user gids
	typeset func_name="${FUNCNAME:=${.sh.fun}}"
  	id -G
	return $?
}

# -----------------------------------------------------------------------------
hasRoot(){

	# Description: evaluate if user has root previleges
	# Arguments  : user (optional; defaults to current user)
	# Returns    : boolean; true if has root previleges, false otherwise
  	# Notes      : evaluate root through the groups command:
	#                wheel on RH, Arch
	#                sudo on Debian

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset user

	if [ -n "${1}" ]; then
  		user="${1}"
  	else
  		user="${USER}"
  	fi

  	groups ${user} | grep -q -e sudo -e wheel
  	return $?
}

# -----------------------------------------------------------------------------
# file / directory information and management
# -----------------------------------------------------------------------------
dirExists(){

	# Description: evaluates if a directory exists
	# Arguments  : 
	#       -1: /path/to/dir
	# Returns    :
	#       -0: success
	#       -127: directory does not exist

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset directory="${1}"
	[ -d "${directory}" ] || return 127
}

# -----------------------------------------------------------------------------
makeDir(){

	# Description: creates a directory
	# Arguments  : 
	#       -1: /path/to/dir
	# Returns    :
	#       -0: success
	#       -1: Permission denied

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset directory="${1}"
	mkdir -p "${directory}"
	return ${?}	
}


# -----------------------------------------------------------------------------
getFileType(){

	# Description: returns the type of a file: regular, directory, link
	# Arguments  : 
	#       -1: /path/to/dir_file
	# Returns    :
	#       -0: type not defined
	#		-1:	directory
	#		-2:	regular file
	#		-3:	simbolic link to directory
	#		-4:	simbolic link to file
	#       -127: file not found
	#       -128: argument missing

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset file="${1}"
	[ -n "${file}" ] || 
		{ 
			printf "error ${func_name}: missing argument\n" 1>&2; 
			return 128;
		}
	typeset rc=0

	if [ -e ${file} ]; then
		if [ -d ${file} ]; then
			typeset bit_aux=$(ls -ld ${file} | cut -c1)
			if [ "${bit_aux}" == 'l' ]; then
				rc=3
			else
				rc=1
			fi
		elif [ -f ${file} ]; then
			rc=2
		elif [ -L ${file} ]; then
			rc=4
		else
			rc=0
		fi
	else
		rc=127
	fi

	return ${rc}
}

# -----------------------------------------------------------------------------
changeMode(){

	# Description: changes file / directory permissions
	# Arguments  : 
	#       -1: /path/to/dir_file
	#		-2: permissions octet
	# Returns    :
	#       -0: success
	#       -1: error ...

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset directory="${1}"
	typeset octet="${2}"

	[ -z "${octet}" ] && octet="755"
	chmod "${octet}" "${directory}"
	return ${?}	
}

# -----------------------------------------------------------------------------
# cloud drives information and management
# -----------------------------------------------------------------------------
mountDrive(){

	# Description: mounts a remote drive in background mode
	# Arguments  : 
	#       -1: remote drive 
	#		-2: /path/to/mountpoint
	# Returns    :
	#       -0: success
	#       -1: remote drive already mounted
	#		- 127 : specified mountpoint does not exist
	# Notes   : the mountpoint must exist before being mounted
	#			to mount a specific directory include it in remote drive argument

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset drive="${1}"
	typeset mountpoint="${2}"

	dirExists "${mountpoint}" ] || return 127

	rclone mount --daemon "${drive}" "${mountpoint}"
	return ${?}	
}

# -----------------------------------------------------------------------------
unmountDrive(){

	# Description: unmounts a remote drive created in background mode
	# Arguments  : 
	#       -1: /path/to/mountpoint
	# Returns    :
	#       -0: success
	#		-127: specified mountpoint does not exist
	# Notes   : the mountpoint must be explicitly unmounted

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset mountpoint="${1}"

	[ ! -d "${mountpoint}" ] && return 127

	fusermount -u "${mountpoint}"
	return ${?}	
}

# -----------------------------------------------------------------------------
listDrives(){

	# Description: list's available cloud drives
	# Arguments  : N/A
	# Returns    : a list of available cloud drives
	#       -0: success
	#		-127: specified mountpoint does not exist
	# Notes   : the mountpoint must be explicitly unmounted

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset -a drives=$(rclone listremotes)
	printf "${drives}\n"
}

# -----------------------------------------------------------------------------
getDriveStatus(){

	# Description: returns the drive status
	# Arguments  :
	#       -1: drive to check
	# Returns    : drive status
	#       -0: mounted
	#		-1: unmounted
	#       -128: argument missing

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset -a drive=${1}
	[ -n "${drive}" ] || 
		{ 
			printf "error ${func_name}: missing argument\n" 1>&2; 
			return 128;
		}
	mount | grep -q "${drive}"
	typeset rc=${?}

	return ${rc}
}


# -----------------------------------------------------------------------------
# misc
# -----------------------------------------------------------------------------
notify(){

	# Description: send a notification for sucess / error
	# Arguments  : 
	#       -1: urgency=low, normal, critical
	#       -2: message
	# Returns    :
	#       -0: success

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset urgency="${1}"; shift
	typeset message="${@}" 

	notify-send --urgency="${urgency}" "${message}"
}

# -----------------------------------------------------------------------------
appendPath () {

	# Description: appends a path to a path variable
	# Arguments  : 
	#       -1: variable to edit
	#       -2: value to add
	#       -3: where to append the value: 
	#             "before" | "after" (optional; default "before")
	# Returns    :
	#       -0: success

	typeset func_name="${FUNCNAME:=${.sh.fun}}"
	typeset var_path=${1}
	typeset path_val=${2}
	typeset offset=${3}
	
	typeset var_val=$(eval printf "\${${var_path}}" 2>/dev/null)
	[ "${offset}" = "after" ] || offset="before"

	if [ -z "${var_val}" ]; then
		eval ${var_path}+="${path_val}"
		var_val=$(eval printf \${${var_path}})
	else
		case ":${var_val}:" in
        		*:"${path_val}":*)
            		;;
        		*)
				if [ "${offset}" = "after" ]; then
					eval ${var_path}+=":${path_val}"
				else
					typeset var_path_aux=$(eval printf "\${${var_path}}" 2>/dev/null)
					eval ${var_path}="${path_val}:${var_path_aux}"
				fi
				var_val=$(eval printf \${${var_path}})
			;;
    		esac
	fi

	export $(eval printf "${var_path}")=${var_val}
}


#