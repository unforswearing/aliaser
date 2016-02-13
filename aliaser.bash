#!/bin/bash
IFS=$'\n\t'

helpp () {
	cat <<EOF
aliaser <option> [alias name]

options:
	-s, search [search term]	search aliases
	-l, ls, list			list all aliases
	-r, rm,remove [alias name]	remove an alias
	-d, wd, dir			make alias name from current working directory
	-o, open			view the aliaser file in Finder
	-e, edit			edit alias.txt in EDITOR (or default application)
	-n, name			create alias "Name" for "Directory"
	-c, command			create alias "Name" for "Command"
	-h, help			print this help text and exit

be sure to source the alias file in your .bashrc or .bash_profile
EOF
}

# error checking, not implemented.
_test_() {
	local illegal
	local i

	illegal=( "," "\." "\!" "\@" "\#" "\$" "\%" "\^" "\&" "\*" "\(" "\)" "\+" "\=" "\?" "\{" "\}" "\[" "\]" "\|" "\~" )
	for i in "${illegal[@]}"; do
		if [[ "$2" =~ ^$i ]]; then
			echo "Illegal Character ("$i"). Exiting..."
			exit
		fi
	done
}

config=""${HOME}"/.aliaser.cfg"

if [[ ! -f "$config" ]]; then
    read -r -p "Enter the path to your alias file: " aliasfile
    echo "alias-file="$aliasfile"" > ""${HOME}"/.aliaser.cfg"
    echo ""$aliasfile" set as alias file."
fi

file=$(awk -F '=' '{print $2}' ""${HOME}"/.aliaser.cfg")
filedir=$(dirname "$file")
filename=$(basename "$file")

_open() {
    find ""$filedir"/" -type f -name "$filename" -exec open {} +
    echo "Opening "$file""
}

_list() {
    # cat "$file"
    echo "Printing aliases"
    sleep .2
    find "$filedir/" -type f -name "$filename" -exec cat {} +;
}

_edit() {
    find ""$filedir"/" -type f -name "$filename" -exec "$EDITOR" {} +
}

_remove() {
    grep -iv "$2" "$file" > .arm.tmp
    cat .arm.tmp > "$file"
    rm .arm.tmp

    echo "Removed "$2" from aliases"
}

_dir() {
	local name
    local dir

    name=$(basename "$(pwd)")
    dir=$(pwd|sed 's/ /\\ /')

	printf "alias "$name"='cd "$dir"'" >> "$file";
    printf '\n' >> "$file"
    echo "Alias for "$dir" added to "$file""
}

_named() {
    echo "alias "$2"='cd "$3"'" >> "$file"
    printf '\n' >> "$file"
    echo "Alias for "$2" created for "$3""
}

_search() {
	if [[ "$2" == "" ]]; then
		printf "aliaser search needs an alias name to search for";
	else
        echo "Search results for "$2""
        grep -i "$2" "$file"
    fi
}

_command() {
    printf '\n' >> "$file"
    echo "alias "$2"='"$3"'" >> "$file";
    echo "Alias "$2" created for "$3""
}

case "$1" in
	-h|--help|help|"") helpp; . "$file";;
	-o|open) _open; . "$file";;
	-l|ls|list) _list; . "$file";;
	-e|edit) _edit; . "$file";;
	-r|rm|remove) _remove "$@"; . "$file";;
	-d|wd|dir) _dir; . "$file";;
    -n|name) _named "$@"; . "$file";;
	-s|search) _search "$@"; . "$file";;
    -c|command) _command "$@"; . "$file";;
esac
