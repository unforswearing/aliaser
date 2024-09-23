const () {
	libutil:argtest "$1"
	libutil:argtest "$2"
	local name="$1" 
	shift
	local value="$*" 
	declare -rg "$name=$@"
	consts["$name"]="$@" 
	stdtypes["$name"]="const" 
	eval "function $name() print $value"
}
