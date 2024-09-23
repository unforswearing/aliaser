append () {
	libutil:argtest "$1"
	libutil:argtest "$2"
	local txt="${1}" 
	local file="${2}" 
	if [[ ! -s "$file" ]]
	then
		libutil:error.nofile "$file"
	else
		shift
		printf "%s\n" "$txt" >>| "$file"
	fi
}
