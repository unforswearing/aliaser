#!/bin/bash
# shellcheck shell=bash

# Enable some optional \shellcheck checks:
# shellcheck enable=add-default-case
# shellcheck enable=avoid-nullary-conditions
# shellcheck enable=quote-safe-variables
# shellcheck enable=require-double-brackets
# shellcheck enable=require-variable-braces

# aliaser is a self-editing alias management tool.
function aliaser() {
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
    edit      edit alias file in ${EDITOR}
    search    search alias file, select and print matches
    open      open the 'aliaser.sh' script in ${EDITOR}
    clearall  remove all aliases from this alias file

  Running 'aliaser' without an option flag will allow you to save aliases
  to this script in a slightly more traditional manner:

    # note: the entire alias must be quoted
    aliaser "cd_home_ls='cd \$HOME && ls'"

Source:
  https://github.com/unforswearing/aliaser
EOF
  }

  aliaser_self="${ALIASER_SOURCE}"

  _list() {
   # shellcheck disable=SC2016
   gsed -n '/\#\#\:\:\~ Aliases \~\:\:\#\#/,$p' "${aliaser_self}"
  }
  # _encoded_header() {
  #  echo "IyM6On4gQWxpYXNlcyB+OjojIw=="
  # }
  _decoded_header() {
    echo "IyM6On4gQWxpYXNlcyB+OjojIw==" | /usr/bin/base64 -D
  }
  flag="${1}"
  case "${flag}" in
  # aliaser help
  help | -h) helpp ;;
  # aliaser open
  open) "${EDITOR}" "${aliaser_self}" ;;
  # aliaser list
  list) _list ;;
  edit)
    # aliaser edit
    tmp_aliases_list="/tmp/aliaser_aliases_list.txt"
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
    ;;
  dir)
    # aliaser dir "zsh_config" "~/zsh-config"
    dirname="${2}"
    dirpath="${3}"
    composed_alias="alias ${dirname}='cd \"${dirpath}\"'"
    eval "${composed_alias}"
    echo "${composed_alias}" >>"${aliaser_self}"
    echo "Added: alias '${dirname}':"
    echo "  > cd \"${dirpath}\""
    echo
    ;;
  lastcmd)
    # aliaser lastcmd "name"
    prev=$(
      history |
      /usr/bin/tail -n 1 |
      /usr/bin/awk '{first=$1; $1=""; print $0;}' |
      /usr/bin/awk '{$1=$1}1'
    )
    composed_alias="alias ${2}='${prev}'"
    eval "${composed_alias}"
    echo "${composed_alias}" >>"${aliaser_self}"
    echo "Added: alias '${2}':"
    echo "  > \"${prev}\""
    echo
    ;;
  search)
    # aliaser search <query>
    query="${2}"
    matches=$(_list | /usr/bin/awk '/'"${query}"'/')
    test -z "${matches}" && {
      echo "No match found for '${query}'"
      return
    }
    printf '%s\n' "${matches}" |
      grep -v "$(_decoded_header)" |
      fzf --disabled --select-1 --exit-0 |
      awk -F= '{print $2}' |
      sd "\'" ""
    ;;
  debug)
    echo "[DEBUG]"
    debug_cmd_types() {
      type -a gsed
      type -a awk
      type -a cat
      type -a rm
      type -a tail
      type -a fzf
    }
    debug_cmd_types
    ;;
  clearall)
    header="$(_decoded_header)"
    # shellcheck disable=SC2016
    gsed -i '/'"${header}"'/,$d' "${aliaser_self}"
    echo "${header}" >> "${aliaser_self}"
    echo "All aliases have been deleted."
  ;;
  *)
    # aliaser "zsh_config='cd ~/zsh-config'"
    eval "alias ${*}"
    echo "alias ${*}" >> "${aliaser_self}"
    echo "Added:"
    echo "  > alias ${*}"
    echo
    ;;
  esac
  # Backup aliaser somewhere just in case (actual location TBD)
  # cat "${aliaser_self}" > "${aliaser_self}.bkp"
}

## ---------------

##::~ Aliases ~::##

alias projects_dir='cd "$HOME/projects"'
alias wakeup='sleep 2 && echo awake'
