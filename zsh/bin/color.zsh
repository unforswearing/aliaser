color () {
	local red="\033[31m"
	local green="\033[32m"
	local yellow="\033[33m"
	local blue="\033[34m"
	local reset="\033[39m"
	local black="\033[30m"
	local white="\033[37m"
	local magenta="\033[35m"
	local cyan="\033[36m"
	local opt="$1"
	shift
	case "$opt" in
		(red) print "${red}$@${reset}" ;;
		(green) print "${green}$@${reset}" ;;
		(yellow) print "${yellow}$@${reset}" ;;
		(blue) print "${blue}$@${reset}" ;;
		(black) print "${black}$@${reset}" ;;
		(white) print "${white}$@${reset}" ;;
		(magenta) print "${magenta}$@${reset}" ;;
		(cyan) print "${cyan}$@${reset}" ;;
		(help) print "colors <red|green|yellow|blue|black|magenta|cyan> string" ;;
	esac
}
