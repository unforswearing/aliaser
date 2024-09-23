branch () {
	libutil:argtest "$1"
	local opt="$1" 
	/bin/mkdir -p "$opt"
}
