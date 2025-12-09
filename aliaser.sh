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
function aliaser() {
  flag="${1}"
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
  # TODO: Consolidate dependency checks. Remove the two 'command -v $name'
  #       functions after lib::check_dependencies is tested and live.
  # lib::check_dependencies() {
  #   local requirements=("gsed" "fzf")
  #   for item in "${requirements[@]}"; do
  #     if ! command -v "${item}" >|/dev/null 2>&1; then
  #       echo "'${item}' not found. aliaser on MacOS requires '${item}'"
  #       return 1
  #     fi
  #   done
  # }
  command -v gsed >|/dev/null 2>&1 || {
    echo "'gsed' not found. aliaser on MacOS requires 'gsed'."
    echo "https://www.gnu.org/software/sed/"
    return
  }
  command -v fzf >|/dev/null 2>&1 || {
    echo "'fzf' not found. aliaser requires FZF for use with the 'search' option."
    echo "https://github.com/junegunn/fzf"
    return
  }
  # lib::confirm_alias() {
  #   local name="${1}"
  #   local value="${2}"
  #   echo "Added: alias '${alias_name} = ${alias_value}'"
  #   echo
  #  }
  #
  # lib::help() {
  helpp() {
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
  readonly aliaser_self="${ALIASER_SOURCE}"
  readonly encoded_header="IyM6On4gQWxpYXNlcyB+OjojIw=="
  # lib::decoded_header() {
  _decoded_header() {
    echo "${encoded_header}" | /usr/bin/base64 -D
  }
  # lib::debug() {
  _aliaser_debug() {
    echo "[DEBUG]"
    debug_cmd_types() {
      type -a cat
      type -a awk
      type -a grep
      type -a rm
      type -a tail
      type -a fzf
      type -a gsed
    }
    debug_cmd_types
  }
  # ------------
  # make a generic "error" function that will cover multiple scenarios?
  # colorize error output?
  # ------------
  # lib::error.missing_value() {
  #   if [[ -z "${1}" || -z "${2}" ]]; then
  #     echo "Error: Missing Value."
  #     return 1
  #   fi
  # }
  #
  # lib::error.empty_arg() {
  error_empty_arg() {
    echo "Error: Empty argument. Run 'aliaser help' for assistance."
  }
  # ------------
  # cmd::list() {
  cmd_aliaser_list() {
    # shellcheck disable=SC2016
    gsed -n '/\#\#\:\:\~ Aliases \~\:\:\#\#/,$p' "${aliaser_self}"
  }
  # cmd::edit() {
  cmd_aliaser_edit() {
    # aliaser edit
    tmp_aliases_list="/tmp/aliaser_aliases_list_${$}.txt"
    _list >"${tmp_aliases_list}"
    "${EDITOR}" "${tmp_aliases_list}"
    header="$(_decoded_header)"
    # shellcheck disable=SC2016
    gsed -i '/'"${header}"'/,$d' "${aliaser_self}"
    /bin/cat "${tmp_aliases_list}" >>"${aliaser_self}"
    # /bin/rm "${tmp_aliases_list}"
    # shellcheck disable=SC1090
    source "${aliaser_self}"
    echo "Updated aliases."
  }
  # TODO: Confirmation of newly created aliases should be a single function.
  # cmd::dir() {
  cmd_aliaser_dir() {
    # aliaser dir "zsh_config" "~/zsh-config"
    dirname="${2}"
    dirpath="${3}"
    # lib::error.missing_value "${dirname}" "${dirpath}"
    composed_alias="alias ${dirname}='cd \"${dirpath}\"'"
    eval "${composed_alias}"
    echo "${composed_alias}" >>"${aliaser_self}"
    # lib::confirm_alias "${dirname}" "${dirpath}"
    echo "Added: alias '${dirname}':"
    echo "  > cd \"${dirpath}\""
  }
  # cmd::lastcmd() {
  cmd_aliaser_lastcmd() {
    # aliaser lastcmd "name"
    prev=$(
      history |
        /usr/bin/tail -n 1 |
        /usr/bin/awk '{first=$1; $1=""; print $0;}' |
        /usr/bin/awk '{$1=$1}1'
    )
    # lib::error.missing_value "${2}" "NONE"
    composed_alias="alias ${2}='${prev}'"
    eval "${composed_alias}"
    echo "${composed_alias}" >>"${aliaser_self}"
    # lib::confirm_alias "${2}" "${prev}"
    echo "Added: alias '${2}':"
    echo "  > \"${prev}\""
  }
  # cmd::search() {
  cmd_aliaser_search() {
    # aliaser search <query>
    query="${2}"
    # lib::error.missing_value "${query}" "NONE"
    # matches=$(cmd::list | /usr/bin/awk '/'"${query}"'/')
    matches=$(_list | /usr/bin/awk '/'"${query}"'/')
    test -z "${matches}" && {
      echo "No match found for '${query}'"
      return
    }
    printf '%s\n' "${matches}" |
      # /usr/bin/grep -v "$(lib::decoded_header)" |
      /usr/bin/grep -v "$(_decoded_header)" |
      fzf --disabled --select-1 --exit-0 |
      /usr/bin/awk -F= '{print $2}' |
      gsed -E "s/^'//g;s/'$//g"
  }
  # cmd::clearall() {
  cmd_aliaser_clearall() {
    # header="$(lib::decoded_header)"
    header="$(_decoded_header)"
    # shellcheck disable=SC2016
    gsed -i '/'"${header}"'/,$d' "${aliaser_self}"
    local aliaser_bkp="/tmp/aliaser_clearall.bkp"
    # cmd::list >>"${aliaser_bkp}"
    cmd_aliaser_list >>"${aliaser_bkp}"
    echo "${header}" >>"${aliaser_self}"
    echo "All aliases have been deleted."
    echo "A backup of your aliases has been saved to ${aliaser_bkp}."
  }
  # --------------------------
  ## Argument processing begins here:
  # $flag is set at the start of the aliaser function
  case "${flag}" in
  help | -h) helpp ;;
  open) "${EDITOR}" "${aliaser_self}" ;;
  list) cmd_aliaser_list ;;
  edit) cmd_aliaser_edit ;;
  dir) cmd_aliaser_dir "$@" ;;
  lastcmd) cmd_aliaser_lastcmd "$@" ;;
  search) cmd_aliaser_search "$@" ;;
  clearall) cmd_aliaser_clearall ;;
  debug) _aliaser_debug ;;
  "") error_empty_arg ;;
  *)
    # aliaser "zsh_config='cd ~/zsh-config'"
    eval "alias ${*}"
    echo "alias ${*}" >>"${aliaser_self}"
    echo "Added:"
    echo "  > alias ${*}"
    ;;
  esac
}
## ---------------

##::~ Aliases ~::##

alias projects_dir='cd "$HOME/projects"'
alias wakeup='sleep 2 && echo awake'
