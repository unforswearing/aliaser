cmd () {
	libutil:argtest "$1"
	cmd.cpl () {
		require "pee"
		local OIFS="$IFS"
		IFS=$'\n\t'
		local comm
		comm=$(history | tail -n 1 | awk '{first=$1; $1=""; print $0;}')
		echo "${comm}" | pee "pbcopy" "cat - | sd '^\s+' ''"
		IFS="$OIFS"
	}
	cmd.discard () {
		eval "$@" >| /dev/null 2>&1
	}
	cmd.devnull () {
		true >| /dev/null
	}
	cmd.norcs () {
		env -i zsh --no-rcs -c "$@"
	}
	cmd.withopt () {
		local opt="$1"
		shift
		setopt "$opt"
		eval "$@"
	}
	cmd.noopt () {
		local opt="$1"
		shift
		unsetopt "$opt"
		eval "$@"
	}
	cmd.settimeout () {
		local opt="$1"
		shift
		(
			sleep "$opt" && eval "$@"
		) &
	}
	local opt="$1"
	shift
	case "$opt" in
		(last) cmd.cpl ;;
		(discard) libutil:argtest "$@" && cmd.discard "$@" ;;
		(devnull) cmd.devnull ;;
		(norcs) cmd.norcs "$@" ;;
		(withopt) cmd.withopt "$@" ;;
		(noopt) cmd.noopt "$@" ;;
		(timeout) cmd.settimeout "$@" ;;
		(*) libutil:error.option "$opt" ;;
	esac
}
