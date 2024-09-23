write () {
	local opt="${1:-$(cat -)}" 
	libutil:argtest "$opt"
	if [[ -s "$opt" ]]
	then
		libutil:error.overwrite "$opt"
	else
		printf "%s\n" "$@" >| "$opt"
	fi
}
