#!/bin/bash

aliaser() {
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

  # https://github.com/gko/listbox
  listbox() {
    while [[ $# -gt 0 ]]
    do
      key="$1"

      case $key in
        -h|--help)
          echo "choose from list of options"
          echo "Usage: listbox [options]"
          echo "Example:"
          echo "  listbox -t title -o \"option 1|option 2|option 3\" -r resultVariable -a '>'"
          echo "Options:"
          echo "  -h, --help                         help"
          echo "  -t, --title                        list title"
          echo "  -o, --options \"option 1|option 2\"  listbox options"
          echo "  -r, --result <var>                 result variable"
          echo "  -a, --arrow <symbol>               selected option symbol"
          return 0
          ;;
        -o|--options)
          local OIFS=$IFS;
          IFS="|";
          # check if zsh/bash
          if [ -n "$ZSH_VERSION" ]; then
            IFS=$'\n' opts=($(echo "$2" | tr "|" "\n"))
          else
            IFS="|" read -a opts <<< "$2";
          fi
          IFS=$OIFS;
          shift
          ;;
        -t|--title)
          local title="$2"
          shift
          ;;
        -r|--result)
          local __result="$2"
          shift
          ;;
        -a|--arrow)
          local arrow="$2"
          shift
          ;;
        *)
      esac
      shift
    done

    if [[ -z $arrow ]]; then
      arrow=">"
    fi

    local len=${#opts[@]}

    local choice=0
    local titleLen=${#title}

    if [[ -n "$title" ]]; then
      echo -e "\n  $title"
      printf "  "
      printf %"$titleLen"s | tr " " "-"
      echo ""
    fi

    draw() {
      local idx=0 
      for it in "${opts[@]}"
      do
        local str="";
        if [ $idx -eq $choice ]; then
          str+="$arrow "
        else
          str+="  "
        fi
        echo "$str$it"
        idx=$((idx+1))
      done
    }

    move() {
      for it in "${opts[@]}"
      do
        tput cuu1
      done
      tput el1
    }

    listen() {
      while true
      do
        key=$(bash -c "read -n 1 -s key; echo \$key")

        if [[ $key = q ]]; then
          break
        elif [[ $key = B ]]; then
          if [ $choice -lt $((len-1)) ]; then
            choice=$((choice+1))
            move
            draw
          fi
        elif [[ $key = A ]]; then
          if [ $choice -gt 0 ]; then
            choice=$((choice-1))
            move
            draw
          fi
        elif [[ $key = "" ]]; then
          # check if zsh/bash
          if [ -n "$ZSH_VERSION" ]; then
            choice=$((choice+1))
          fi

          if [[ -n $__result ]]; then
            eval "$__result=\"${opts[$choice]}\""
          else
            echo -e "\n${opts[$choice]}"
          fi
          break
        fi
      done
    }

    draw
    listen
  }

  # illegal character checking, not implemented.
  _test_() {
    local illegal
    local i

    illegal=( "," "\." "\!" "\@" "\#" "\$" "\%" "\^" "\&" \
              "\*" "\(" "\)" "\+" "\=" "\?" "\{" "\}" "\[" "\]" "\|" "\~" );

    for i in "${illegal[@]}"; do
      if [[ "$2" =~ ^$i ]]; then
        echo "Illegal Character ("$i"). Exiting..."
        exit
      fi
    done
  }

  ########################################
  config=""${HOME}"/.aliaser/aliaser.conf"
  ########################################

  if [[ ! -f "$config" ]]; then
    read -r -p "Enter the path to your alias file: " aliasfile
    echo "alias_file=$aliasfile" > "$config"
    echo ""$aliasfile" set as alias file."
  fi

  file=$(awk -F '=' '{print $2}' "$config")
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
      local srch="$2"
      
      # unused for now choosefromlist seems to work on home laptop
      listresults() {
        echo "Search results for \""$srch"\":"
        echo "-------------------------------"
        grep -i "$srch" "$file"
        echo

      }

      choosefromlist() {
        results() { 
          grep -i "$srch" "$file" | sed "s/\#.*//g" | grep -v '^$' | tr '\n' '\|'
        
        }

        listbox -t "Search results for "\"$srch\""" -o "$(results "$@")CANCEL SEARCH" -r comm -a "⇨"

        local toexec=$(
          echo "$comm" | \
          awk -F '=' '{print $2}' | \
          sed "s/'//g" | \
          sed "s|~|/Users/$(whoami)|g"
        );

        local trigger=$(echo $toexec | awk -F ' ' '{print $1}')
        local directory=$(echo $toexec | sed 's/cd //g')

        if [[ $trigger == "cd" ]]; then
          # navigating to a directory works ONLY on home laptop
          pushd $directory > /dev/null 2>&1

        else 
          # executing commands does work
          eval "$toexec"
        fi

      }

      choosefromlist
      # listresults

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
}