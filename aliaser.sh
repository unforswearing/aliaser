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
function _aliaser() {
  readonly flag="${1}"
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
  local requirements=("gsed" "fzf")
  for item in "${requirements[@]}"; do
    if ! command -v "${item}" >|/dev/null 2>&1; then
      echo "'${item}' not found. aliaser on MacOS requires '${item}'"
      return 1
    fi
  done
  # command -v gsed >|/dev/null 2>&1 || {
  #   echo "'gsed' not found. aliaser on MacOS requires 'gsed'."
  #   echo "https://www.gnu.org/software/sed/"
  #   return
  # }
  # command -v fzf >|/dev/null 2>&1 || {
  #   echo "'fzf' not found. aliaser requires FZF for use with the 'search' option."
  #   echo "https://github.com/junegunn/fzf"
  #   return
  # }
  #
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
    edit      edit alias file in '\$EDITOR' (${EDITOR:=unset})
    search    search alias file, select and print matches
    open      open the 'aliaser.sh' script in '\$EDITOR' (${EDITOR:=unset})
    clearall  remove all aliases from this alias file

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
  	local red; red=$(/usr/bin/tput setaf 1)
    local message="${*}"
    printf '%s%s\n' "${red}" "${message}"
  }
  # lib::color.green() {
	#   local green; green=$(/usr/bin/tput setaf 2)
  #   local message="${*}"
  #   printf '%s%s\n' "${green}" "${message}"
  # }
  lib::error.missing_value() {
    if [[ -z "${1}" || -z "${2}" ]]; then
      lib::color.red "Error: Missing Value."
      return 1
    fi
  }
  lib::error.empty_arg() {
    lib::color.red "Error: Empty argument. Run 'aliaser help' for assistance."
  }
  lib::encoded_header() {
    echo "IyM6On4gQWxpYXNlcyB+OjojIw=="
  }
  lib::decoded_header() {
    lib::encoded_header | /usr/bin/base64 -D
  }
  # TODO: Confirmation of newly created aliases should be a single function.
  # lib::confirm_alias() {
  #   local name="${1}"
  #   local value="${2}"
  #   lib::color.green "Added: alias '${name} = ${value}'"
  #   echo
  # }
  # ------------
  # aliaser list
  cmd::list() {
    # shellcheck disable=SC2016
    gsed -n '/\#\#\:\:\~ Aliases \~\:\:\#\#/,$p' "${ALIASER_SOURCE}"
  }
  # aliaser edit
  cmd::edit() {
    tmp_aliases_list="/tmp/aliaser_aliases_list_${$}.txt"
    _list >"${tmp_aliases_list}"
    "${EDITOR}" "${tmp_aliases_list}"
    # shellcheck disable=SC2016
    gsed -i '/'"$(lib::encoded_header)"'/,$d' "${ALIASER_SOURCE}"
    /bin/cat "${tmp_aliases_list}" >>"${ALIASER_SOURCE}"
    # /bin/rm "${tmp_aliases_list}"
    # shellcheck disable=SC1090
    source "${ALIASER_SOURCE}"
    echo "Updated aliases."
  }
  # aliaser dir "zsh_config" "~/zsh-config"
  cmd::dir() {
    dirname="${2}"
    dirpath="${3}"
    lib::error.missing_value "${dirname}" "${dirpath}"
    composed_alias="alias ${dirname}='cd \"${dirpath}\"'"
    eval "${composed_alias}"
    echo "${composed_alias}" >>"${ALIASER_SOURCE}"
    # lib::confirm_alias "${dirname}" "${dirpath}"
    echo "Added: alias '${dirname}':"
    echo "  > cd \"${dirpath}\""
  }
  # aliaser lastcmd "name"
  cmd::lastcmd() {
    prev=$(
      history |
        /usr/bin/tail -n 1 |
        /usr/bin/awk '{first=$1; $1=""; print $0;}' |
        /usr/bin/awk '{$1=$1}1'
    )
    lib::error.missing_value "${2}"
    composed_alias="alias ${2}='${prev}'"
    eval "${composed_alias}"
    echo "${composed_alias}" >>"${ALIASER_SOURCE}"
    # lib::confirm_alias "${2}" "${prev}"
    echo "Added: alias '${2}':"
    echo "  > \"${prev}\""
  }
  # aliaser search <query>
  cmd::search() {
    query="${2}"
    lib::error.missing_value "${query}"
    matches=$(cmd::list | /usr/bin/awk '/'"${query}"'/')
    test -z "${matches}" && {
      echo "No match found for '${query}'"
      return
    }
    printf '%s\n' "${matches}" |
      /usr/bin/grep -v "$(lib::decoded_header)" |
      fzf --disabled --select-1 --exit-0 |
      /usr/bin/awk -F= '{print $2}' |
      gsed -E "s/^'//g;s/'$//g"
  }
  # aliaser clearall
  cmd::clearall() {
    # shellcheck disable=SC2016
    gsed -i '/'"$(lib::decoded_header)"'/,$d' "${ALIASER_SOURCE}"
    local aliaser_bkp="/tmp/aliaser_clearall.bkp"
    cmd::list >>"${aliaser_bkp}"
    lib::decoded_header >>"${ALIASER_SOURCE}"
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
  clearall) cmd::clearall ;;
  "") lib::error.empty_arg ;;
  *)
    # aliaser "zsh_config='cd ~/zsh-config'"
    eval "alias ${*}"
    echo "alias ${*}" >>"${ALIASER_SOURCE}"
    echo "Added:"
    echo "  > alias ${*}"
    ;;
  esac
}
## ---------------

##::~ Aliases ~::##

alias projects_dir='cd "$HOME/projects"'
alias wakeup='sleep 2 && echo awake'
