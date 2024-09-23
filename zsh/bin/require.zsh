# shellcheck shell=bash
require () {
	local comm
	comm="$(command -v "$1")" 
	if [[ -n $comm ]]
	then
		true
	else
		color red "$0: command '$1' not found" && return 1
	fi
}
