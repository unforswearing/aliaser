#!/bin/bash
# shellcheck shell=bash

# Enable some optional \shellcheck checks:
# shellcheck enable=add-default-case
# shellcheck enable=avoid-nullary-conditions
# shellcheck enable=quote-safe-variables
# shellcheck enable=require-double-brackets
# shellcheck enable=require-variable-braces

# aliaser is a self-editing alias management tool.
##:: aliaser-version=v2.2.1
function dev_aliaser() {
  local flag="${1}"
  #######################################################################
  # ------------
  # Runtime checks
  # ------------
  # Check for the value of ALIASER_SOURCE environment variable.
  # Stop and exit if this value does not exist.
  test -z ${ALIASER_SOURCE+x} && {
    echo "The 'aliaser' function can only work when the '\$ALIASER_SOURCE'"
    echo "environment variable is set. Please add the following code to your dotfiles:"
    echo
    echo "ALIASER_SOURCE=\"path/to/aliaser.sh\""
    echo "source \"\$ALIASER_SOURCE\""
    echo
    echo "Or run 'export ALIASER_SOURCE=\"path/to/aliaser.sh\"' before executing"
    echo "the 'aliaser' command."
    return
  }
  # Check MacOS dependencies. This doesn't need to be a function
  # TODO: Remove dependency on gsed.
  # Update - gsed has been replaced with bash or sed commands. CURRENTLY TESTING.
  # local requirements=("gsed" "fzf")
  # for item in "${requirements[@]}"; do
  if ! command -v "fzf" >|/dev/null 2>&1; then
    echo "'fzf' not found. aliaser on MacOS requires 'fzf'"
    return 1
  fi
  # done
  #######################################################################
  # ------------
  # Aliaser library helper commands
  # ------------
  # Store paths that are used more than once.
  # TODO: standardize these path names
  # Currently unused. Needs to be tested [12/16/2025].
  # declare -a lib_paths;
  # ref. 'cmd::edit' -- temporary aliases file
  # lib_paths[0]="/tmp/aliaser_aliases_list_${RANDOM}.txt"
  # ref. 'cmd::edit' and 'cmd::clear_all' -- temporary container aliaser.sh script without aliases
  # lib_paths[1]="/tmp/aliaser_raw.tmp"
  # ref. 'cmd::clear_all' -- backup for 'cmd::list' specific to 'clear_all'
  # lib_paths[2]="/tmp/aliaser_clear_all.bkp"
  # ref. 'lib::dump.aliases' -- store a tmp copy of "${ALIASER_SOURCE}"
  # lib_paths[3]="/tmp/aliaser_full.tmp"
  ## --------------------------------
  # `aliaser help` or `aliaser ""` (no argument)
  lib::help() {
    cat <<EOF
aliaser <option> [alias name]

Description:
  'aliaser' is a self-editing alias management script, primarily for use on MacOS.

  Add the following to your dotfiles to use 'aliaser' in your shell:

    export ALIASER_SOURCE="path/to/aliaser"
    source "\$ALIASER_SOURCE"

Options:
    help      display this help message
    list      list aliases saved in alias file
    dir       create an alias to cd to a directory with a nickname
    lastcmd   create an alias from the previous command in your history
    edit      edit alias file in '\$EDITOR' (${EDITOR:=not set})
    search    search alias file, select and print matches
    open      open the 'aliaser.sh' script in '\$EDITOR' (${EDITOR:=not set})
    clear_all  remove all aliases from this alias file

  Running 'aliaser' without an option flag will allow you to save aliases
  to this script in a slightly more traditional manner:

    # note: the entire alias must be quoted
    aliaser "cd_home_ls='cd \$HOME && ls'"

Source:
  https://github.com/unforswearing/aliaser
EOF
  }
  # ------------
  # make a generic "error" function that will cover multiple scenarios?
  # colorize error output?
  # ------------
  lib::color.red() {
  	local red; red=$(tput setaf 1)
    local message="${*}"
    printf '%s%s\n' "${red}" "${message}"
  }
  lib::color.green() {
	  local green; green=$(tput setaf 2)
    local message="${*}"
    printf '%s%s\n' "${green}" "${message}"
  }
  # Needs to be tested [12/16/2025].
  lib::error.missing_value() {
    if [[ -z "${1}" || -z "${2}" ]]; then
      lib::color.red "Error: Missing Value."
      return 1
    fi
  }
  lib::error.empty_arg() {
    lib::color.red "Error: Empty argument. Run 'aliaser help' for assistance."
  }
  lib::decoded_header() {
    echo "IyM6On4gQWxpYXNlcyB+OjojIw==" | base64 -D
  }
  lib::trim() {
    # if arg $1 is unset, use previous value from pipe
    # meaning, both of these work:
    # `lib::trim "  text   "`
    # `echo "  text  " | lib::trim`
    local text; text="${1:=$(cat -)}"
    text="${text## }"
    text="${text%% }"
    echo "${text}"
  }
 # Needs to be tested [12/16/2025].
  lib::count_lines() {
    wc -l <"${ALIASER_SOURCE}" | lib::trim # awk '{$1=$1};1'
  }
  # Needs to be tested [12/16/2025].
  lib::dump.without_aliases() {
    local header; header="$(lib::decoded_header)"
    while read -r line; do
      if [[ "${line}" =~ ${header} ]]; then
        return
      else
        echo "${line}"
      fi
    done <"${ALIASER_SOURCE}"
  }
  # Only print aliases, without script contents
  # Needs to be tested [12/16/2025].
  lib::dump.aliases() {
    local count=1
    local header; header="$(lib::decoded_header)"
    cat "${ALIASER_SOURCE}" >/tmp/aliaser_full.tmp
    while read -r line; do
      if [[ "${line}" =~ ${header} ]]; then
        local linecount; linecount="$(lib::count_lines)"
        local taillines=$((linecount - (count - 1)))
        tail -n "${taillines}" "/tmp/aliaser_full.tmp"
        return 0
      fi
      count=$((count + 1))
    done <"${ALIASER_SOURCE}"
  }
  # A standard way to confirm alias creation.
  # Needs to be tested [12/16/2025].
  lib::confirm_alias() {
    local name="${1}"
    local value="${2}"
    lib::color.green "Added: alias '${name} = ${value}'"
    echo
  }

  #######################################################################
  # ------------
  # Aliaser option commands
  # ------------
  # aliaser list
  cmd::list() {
    lib::dump.aliases
  }
  # aliaser edit
  cmd::edit() {
    tmp_aliases_list="/tmp/aliaser_aliases_list_${RANDOM}.txt"
    cmd::list >"${tmp_aliases_list}"
    "${EDITOR}" "${tmp_aliases_list}"
    lib::dump.without_aliases >>"/tmp/aliaser_raw.tmp"
    {
      cat "/tmp/aliaser_raw.tmp";
      lib::decoded_header;
      cat "${tmp_aliases_list}";
    } >"${ALIASER_SOURCE}"
    # Shellcheck "Can't follow non-constant source" is irrelevant here.
    # shellcheck disable=SC1090
    source "${ALIASER_SOURCE}"
    echo "Updated aliases."
  }
  # aliaser dir "zsh_config" "~/zsh-config"
  cmd::dir() {
    dirname="${2}"
    dirpath="${3}"
    # lib::error.missing_value "${dirname}" "${dirpath}"
    composed_alias="alias ${dirname}='cd \"${dirpath}\"'"
    eval "${composed_alias}"
    echo "${composed_alias}" >>"${ALIASER_SOURCE}"
    lib::confirm_alias "${dirname}" "${dirpath}"
    # echo "Added: alias '${dirname}':"
    # echo "  > cd \"${dirpath}\""
  }
  # aliaser lastcmd "name"
  cmd::lastcmd() {
    prev=$(
      history |
        tail -n 1 |
        # awk '{first=$1; $1=""; print $0;}' |
        { read -r _ contents; echo "${contents}"; }
    )
    lib::error.missing_value "${2}"
    composed_alias="alias ${2}='${prev}'"
    eval "${composed_alias}"
    echo "${composed_alias}" >>"${ALIASER_SOURCE}"
    lib::confirm_alias "${2}" "${prev}"
    # echo "Added: alias '${2}':"
    # echo "  > \"${prev}\""
  }
  # aliaser search <query>
  cmd::search() {
    query="${2}"
    # lib::error.missing_value "${query}"
    matches=$(cmd::list | tail -n 2 | grep -F "${query}")
    test -z "${matches}" && {
      echo "No match found for '${query}'"
      return
    }
    printf '%s\n' "${matches}" |
      grep -v "$(lib::decoded_header)" |
      fzf --disabled --select-1 --exit-0 |
      cut -d= -f2- |
      while read -r selection; do
        selection="${selection##\'}"
        echo "${selection%%\'}"
      done
  }
  # aliaser clear_all
  cmd::clear_all() {
    local aliaser_bkp="/tmp/aliaser_clear_all.bkp"
    cmd::list >>"/tmp/aliaser_clear_all.bkp"
    lib::dump.without_aliases >>"/tmp/aliaser_raw.tmp"
    {
      cat "/tmp/aliaser_raw.tmp";
      lib::decoded_header ;
    } >>"${ALIASER_SOURCE}"
    echo "All aliases have been deleted."
    echo "A backup of your aliases has been saved to ${aliaser_bkp}."
  }
  # --------------------------
  ## Argument processing begins here:
  # $flag is set at the start of the aliaser function
  case "${flag}" in
  help | -h) lib::help ;;
  open) "${EDITOR}" "${ALIASER_SOURCE}" ;;
  list) cmd::list ;;
  edit) cmd::edit ;;
  dir) cmd::dir "$@" ;;
  lastcmd) cmd::lastcmd "$@" ;;
  search) cmd::search "$@" ;;
  clear_all) cmd::clear_all ;;
  "") lib::error.empty_arg ;;
  *)
    # aliaser "zsh_config='cd ~/zsh-config'"
    eval "alias ${*}"
    echo "alias ${*}" >>"${ALIASER_SOURCE}"
    lib::color.green "Added: alias '${*}'"
    ;;
  esac
}
## ---------------

##::~ Aliases ~::##

alias projects_dir='cd "$HOME/projects"'
alias wakeup='sleep 2 && echo awake'
