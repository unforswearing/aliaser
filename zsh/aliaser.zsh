# shellcheck shell=bash
require fzf

init() {
  aliaser_configuration=
  environ "$XDG_CONFIG_HOME" && {
    aliaser_configuration="${XDG_CONFIG_HOME}/aliaser"
  } || aliaser_configuration="${HOME}/.aliaser"

  mkdir "${aliaser_configuration}"
  touch "${aliaser_configuration}/.aliaser.conf"
  # unlike the original, aliases file lives along side config
  touch "${aliaser_configuration}/.aliases.zsh"
  print "${aliaser_configuration}"
}

tmp_xdg="$XDG_CONFIG_HOME"
tmp_home="$HOME"

# if config dir does not exist in $XDG_CONFIG_HOME or $HOME, run init()
config=
if [[ ! -d "${tmp_xdg}/aliaser" ]] || [[ ! -d "${tmp_home}/.aliaser" ]]; then
  config=$(init)
fi

alias_file="${config}/aliases.zsh"

function aliaser.list_aliases() {
  cat "${alias_file}"
}
function aliaser.edit_aliases() {
  # shellcheck disable=2015
  environ "$EDITOR" && "$EDITOR" "${alias_file}" || {
    color red "$0: variable \$EDITOR is not set."
    return 1
  }
  cmd default "zsh" "${alias_file}"
}
