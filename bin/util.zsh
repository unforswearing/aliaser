# shellcheck shell=bash
# ---
libutil:argtest() {
  # usage libutil:argtest num
  # libutil:argtest 2 => if $1 or $2 is not present, print message
  local caller="$1"
  shift
  if [[ -z "$1" ]]; then
    color red "[ERROR] $caller: argument missing"
    return 1
  fi
}
libutil:timestamp() { "$(date +'%Y-%m-%d %H:%M:%S')"; }
libutil:log() {
  local message="$*"
  color green "$(timestamp) [LOG] $message"
}
libutil:error() {
  local message="$*"
  # Print the error message to stderr with a timestamp
  color red "[ERROR] $message"
}
libutil:error.option() {
  libutil:argtest "$1"
  libutil:argtest "$2"
  local caller="$1"
  local fopt="$2"
  color red "[ERROR] $caller: no method named '$fopt'" && return 1
}
libutil:error.notfound() {
  libutil:argtest "$1"
  libutil:argtest "$2"
  local caller=$1
  local fopt="$2"
  color red "[ERROR] $caller: '$fopt' not found" && return 1
}
# ---
color() {
  declare -A allcolors

	allcolors[red]="\033[31m"
	allcolors[green]="\033[32m"
	allcolors[yellow]="\033[33m"
	allcolors[blue]="\033[34m"
	allcolors[reset]="\033[39m"
	allcolors[black]="\033[30m"
	allcolors[white]="\033[37m"
	allcolors[magenta]="\033[35m"
	allcolors[cyan]="\033[36m"

  libutil:argtest "$1"
	local opt="$1"
	shift
	case "$opt" in
		(red|green|yellow|blue|black|white|magenta|cyan) print "${allcolors[$opt]}$@${reset}" ;;
		(help|*) print "color <red|green|yellow|blue|black|magenta|cyan> string" ;;
	esac
}
require() {
  libutil:argtest "$1"
	local comm
	comm="$(command -v "$1")"
	if [[ -n $comm ]]
	then
		true
	else
		libutil:error.notfound "require" "$comm"
	fi
}
environ () {
	local varname
	varname="$1"
	if [[ -v "$varname" ]] && [[ -n "$varname" ]]
	then
		true
	else
		libutil:error "$0: variable '$1' is not set or is not in environment" && return 1
	fi
}
# This file will mostly be used intectively, however it can
# work as a standalone library when sourced from other zsh scripts.
#

export stdlib="${ZSH_BIN_DIR}/stdlib.zsh"

{ command -v req >/dev/null 2>&1; } || \
  source "${ZSH_BIN_DIR}/req.zsh"

req :mute print

setopt bsd_echo
setopt c_precedences
setopt cshjunkie_loops
setopt function_argzero
setopt ksh_zero_subscript
setopt local_loops
setopt local_options
setopt no_append_create
setopt no_clobber
setopt sh_word_split
setopt warn_create_global

function color() {
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
    red) print "${red}$@${reset}" ;;
    green) print "${green}$@${reset}" ;;
    yellow) print "${yellow}$@${reset}" ;;
    blue) print "${blue}$@${reset}" ;;
    black) print "${black}$@${reset}" ;;
    white) print "${white}$@${reset}" ;;
    magenta) print "${magenta}$@${reset}" ;;
    cyan) print "${cyan}$@${reset}" ;;
    help) print "colors <red|green|yellow|blue|black|magenta|cyan> string" ;;
  esac
}

setopt errreturn

function libutil:reload() { source "${stdlib}"; }
function libutil:argtest() {
  # usage libutil:argtest num
  # libutil:argtest 2 => if $1 or $2 is not present, print message
  local caller=$funcstack[2]
  if [[ -z "$1" ]]; then
    color red "$caller: argument missing"
    return 1
  fi
}
function libutil:error.option() {
  libutil:argtest "$1"
  local caller=$funcstack[2]
  local fopt="$1"
  color red "$caller: no method named '$fopt'" && return 1
}
function libutil:error.notfound() {
  libutil:argtest "$1"
  local caller=$funcstack[2]
  local fopt="$1"
  color red "$caller: $1 not found" && return 1
}
# ---------------
RE_ALPHA="[aA-zZ]"
RE_STRING="([aA-zZ]|[0-9])+"
RE_WORD="\w"
RE_NUMBER="\d"
RE_NUMERIC="^[0-9]+$"
RE_ALNUM="([aA-zZ]|[0-9])"
RE_NEWLINE="\n"
RE_SPACE=" "
RE_TAB="\t"
RE_WHITESPACE="\s"
POSIX_UPPER="[:upper:]"
POSIX_LOWER="[:lower:]"
POSIX_ALPHA="[:alpha:]"
POSIX_DIGIT="[:digit:]"
POSIX_ALNUM="[:alnum:]"
POSIX_PUNCT="[:punct:]"
POSIX_SPACE="[:space:]"
POSIX_WORD="[:word:]"

ERROR_LOG_FILE=
PRINT_STACK_TRACE=

# ---------------
# ifcmd "req" || source req
function ifcmd() {
  libutil:argtest "$1"
  test "$(command -v "${1}")"
}
# ---------------
timestamp() { "$(date +'%Y-%m-%d %H:%M:%S')"; }
log() {
  local message="$*"
  color green "$(timestamp) [LOG] $message"
}
# Function to handle errors with advanced features
error() {
  local exit_code=$1
  shift
  local message="$*"
  local timestamp="$(timestamp)"

  # Print the error message to stderr with a timestamp
  color red "$timestamp [ERROR] $message" >&2
  
  # Log the error message to a file (optional)
  if [[ -n "$ERROR_LOG_FILE" ]]; then
    color red "$timestamp [ERROR] $message" >> "$ERROR_LOG_FILE"
  fi
  
  # Print stack trace (optional)
  if [[ -n "$PRINT_STACK_TRACE" ]]; then
    echo "Stack trace:" >&2
    local i=0
    while caller $i; do
      ((i++))
    done >&2
  fi
  
  # Exit with the provided exit code (optional)
  if [[ "$exit_code" -ne 0 ]]; then
    exit "$exit_code"
  fi
}
# # Example usage
# ERROR_LOG_FILE="/path/to/error.log"  # Set this variable if you want to log errors to a file
# PRINT_STACK_TRACE=1  # Set this variable if you want to print stack traces

# # Example of logging an error with a stack trace
# error 0 "This is a test error message that doesn't exit the script"

# # Example of logging an error, printing a stack trace, and exiting the script
# error 1 "This is a critical error message that will exit the script"
# -----------------------------------------------
function async() { ({ eval "$@"; } &) >/dev/null 2>&1 }
function discard() { eval "$@" >|/dev/null 2>&1 }
# ###############################################
# run a command in another language
function use() {
  local opt="$1"
  shift
  case "$opt" in
  "py") python -c "$@" ;;
  "lua") lua -e "$@" ;;
  "js") node -e "$@" ;;
  esac
}
# Function to retrieve user input with an optional message
function input() {
  local message="$1"
  
  # Print the message if provided
  if [[ -n "$message" ]]; then
    echo -n "$message "
  fi
  
  # Retrieve and return user input
  read user_input
  echo "$user_input"
}
function puts() { echo -en "$@"; }
function putf() {
  libutil:argtest "$1"
  local str="$1"
  shift
  libutil:argtest "$@"
  printf "$str" "$@"
}
# -------------------------------------------------
# do something if the previous command succeeds
and() { (($? == 0)) && "$@"; }
# do something if the previous command fails
or() { (($? == 0)) || "$@"; }
async() { ({ eval "$@"; } &) >/dev/null 2>&1; }
discard() { eval "$@" >|/dev/null 2>&1; }
atom() {
  libutil:argtest "$1" || return
  local nameval="$1"
  eval "$nameval() print $nameval;"
  # if $1 is a number, don't use declare
  declare -rg $nameval="$nameval" >|/dev/null 2>&1
  functions["$nameval"]="$nameval" >|/dev/null 2>&1
  atoms+=("$nameval") >|/dev/null 2>&1
  stdtypes+=("$nameval=atom")
}
nil() {
  libutil:argtest "$1" || return
  # a nil type
  # use `cmd discard` for sending commands to nothingness
  local name="$1"
  local value="$(cat /dev/null)"
  nils+=("$name=$(true)")
  stdtypes+=("$name=nil")
  eval "$name() print $value;"
  declare -rg "$name=$value"
}
safequote() {
  local input="$1"
  local quoted=""

  # Escape special characters
  quoted=$(printf '%q' "$input")

  # Return the safely quoted string
  echo "$quoted"
}
filemod() {
  libutil:argtest "$1"
  libutil:argtest "$2"
  local opt="${1}"
  shift

  f.read() { cat $1; }
  f.write() { local f="$1"; shift; print "$@" >| "$f"; }
  # shellcheck disable=1009,1072,1073
  f.append() { local f="$1"; shift; print "$@" >>| "$f"; }
  f.copy() { local f="$1"; shift; /bin/cp "$f" "$2"; }
  f.newfile() { touch "$@"; }
  f.backup() { cp "${1}"{,.bak}; }
  f.restore() { cp "${1}"{.bak,} && rm "${1}.bak"; }
  f.exists() { [[ -s "${1}" ]]; }
  f.isempty() { [[ -a "${1}" ]] && [[ ! -s "${1}" ]]; }

  case "$opt" in
    read) f.read "${2}" ;;
    write) f.write "${@}" ;;
    append) f.append "${@}" ;;
    copyto) f.copy "${@}" ;;
    newfile) f.newfile "${@}" ;;
    backup) f.backup "${2}";;
    restore) f.restore "${2}" ;;
    exists) f.exists "${2}" ;;
    isempty) f.isempty "${2}" ;;
  esac
}
dirmod() {
  libutil:argtest "$1"
  libutil:argtest "$2"
  dir.new() { mkdir "${1}"; }
  dir.read() { ls "${1}"; }
  dir.backup() { cp -r "${1}" "${1}.bak"; }
  dir.restore() { cp -r "${1}.bak" "${1}" && rm -rf "${1}.bak"; }
  dir.parent() { dirname "${1:-(pwd)}"; }
  dir.exists() { [[ -d "${1}" ]]; }
  dir.isempty() {
    local count=$(ls -la "${1}" | wc -l | trim.left)
    [[ $count -eq 0 ]];
  }
  case "$1" in
    new) dir.new "${2}" ;;
    read) dir.read "${2}" ;;
    backup) dir.backup "${2}" ;;
    restore) dir.restore "${2}" ;;
    parent) dir.parent "${2}" ;;
    exists) dir.exists "${2}" ;;
    isempty) dir.isempty "${2}" ;;
  esac
}
