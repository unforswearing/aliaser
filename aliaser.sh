#!/bin/bash
# This script uses the `sh` extension but aims to be compatible with zsh and bash:
#   - zsh 5.9 (x86_64-apple-darwin24.0)
#   - GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin24)
#
# Tested interactively in zsh and bash shells. See bin/build.sh for unit tests,
# \shellcheck, and formatting.
#

# Enable some optional \shellcheck checks:
# shellcheck enable=add-default-case
# shellcheck enable=avoid-nullary-conditions
# shellcheck enable=quote-safe-variables
# shellcheck enable=require-double-brackets
# shellcheck enable=require-variable-braces

# Can I make aliaser modify its own source code to store links,
# rather than using a config directory? -> Yes!

# aliaser is a config-free alias management tool.

# usage: source aliaser.sh && aliaser help

# requires gnu-sed (gsed on macos)

# clone repo, move files to dotfiles
# add to .{bash|zsh}rc:
# ALIASER_SOURCE="path/to/aliaser"
# source "$ALIASER_SOURCE"

function aliaser() {
  test -z ${ALIASER_SOURCE+x} && {
    echo "The 'aliaser' function can only work with the '\$ALIASER_SOURCE'"
    echo "environment variable. Please add the following code to your dotfiles:"
    echo
    echo "  ALIASER_SOURCE=\"path/to/aliaser\""
    echo " source \"\$ALIASER_SOURCE\""
    echo
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
  open      open the alias file with the default gui editor (e.g. TextEdit)
  list      list aliases saved in alias file
  edit      edit alias file in ${EDITOR}
  dir       create an alias to cd to a directory with a nickname
  lastcmd   create an alias from the previous command in your history
  search    search alias file and execute selection
  clearall  remove all aliases from this alias file

  Running 'aliaser' without a flag will allow you to save aliases to this script in
  a slightly more traditional manner:

    # note: the entire alias must be quoted
    aliaser "cd_home_ls='cd \$HOME && ls'"

Source/Bugs:
  https://github.com/unforswearing/aliaser

EOF
  }

  aliaser_self="${ALIASER_SOURCE}"

  _list() {
    sed -n '/\#\#\:\:\~ Aliases \~\:\:\#\#/,$p' "${aliaser_self}"
  }
  # _encoded_header() {
  #  echo "IyM6On4gQWxpYXNlcyB+OjojIw=="
  # }
  _decoded_header() {
    echo "IyM6On4gQWxpYXNlcyB+OjojIw==" | base64 -D
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
    cat "${tmp_aliases_list}" >>"${aliaser_self}"
    /bin/rm "${tmp_aliases_list}"
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
    prev=$(history | tail -n 1 | awk '{first=$1; $1=""; print $0;}' | awk '{$1=$1}1')
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
    _list | awk '/'"${query}"'/'
    ;;
  debug)
    echo "[DEBUG]"
    # echo "${aliaser_self}"
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
}

## ---------------

##::~ Aliases ~::##

alias projects_dir='cd "$HOME/projects"'
alias wakeup='sleep 2 && echo awake'
