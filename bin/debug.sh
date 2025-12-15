#!/bin/bash

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
