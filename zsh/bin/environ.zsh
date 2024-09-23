environ () {
	local varname
	varname="$1"
	if [[ -v "$varname" ]] && [[ -n "$varname" ]]
	then
		true
	else
		color red "$0: variable '$1' is not set or is not in environment" && return 1
	fi
}
