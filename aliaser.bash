#!/bin/bash

aliaser() {
  IFS=$'\n\t'

  helpp () {
    cat <<EOF
aliaser <option> [alias name]

options:
  -h|help         display this help message
  -o|open         open the alias file with the default gui editor (e.g. TextEdit)
  -l|list         list aliases saved in alias file
  -e|edit         edit alias file in $EDITOR
  -r|rm           remove alias from alias file
  -d|dir          create an alias from the current directory (alias name is basename)
  -n|name         create an alias from the current directory with a user defined name
  -s|search       search alias file and execute selection
  -a|searchall    search all aliases system wide and execute selection
  -c|command      create an alias from the previous command with a user defined name

examples:
  aliaser rm "aliasname"      remove alias named "aliasname" from alias file
  aliaser -n "favoritedir"    add an alias for the current directory named 
                              "favoritedir" to alias file

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

  # see issue: https://github.com/unforswearing/aliaser/issues/4
  if [[ ! -f "$config" ]]; then
    read -r -p "Enter the path to your alias file: " aliasfile
    echo "alias_file=$aliasfile" > "$config"
    echo ""$aliasfile" set as alias file."
  fi

  file=$(awk -F '=' '{print $2}' "$config")
  filedir=$(dirname "$file")
  filename=$(basename "$file")

  _open() {
    if [[ $(uname -s) == "Linux" ]]; then open="$(which xdg-open)";
    else open="$(which open)";
    fi

    find ""$filedir"/" -type f -name "$filename" -exec "$open" {} +
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

    unalias "$2"

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
    if [[ "$1" == "-a" ]] || [[ "$1" == "searchall" ]]; then
      unset file;
      alias > ~/.aliaser/aliaserall.tmp
      file=~/.aliaser/aliaserall.tmp
    fi

    if [[ "$2" == "" ]]; then
      printf "aliaser search needs an alias name to search for";

    else 
      local srch="$2"
      
      # unused for now choosefromlist seems to work on home laptop
      listresults() {
        echo "Search results for \""$srch"\":"
        echo "-------------------------------"
        grep -i "$srch" $file
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

    fi

  }

  _command() {
    # printf '\n' >> "$file"
    function _cralias () {
      history | tail -n 2 | sort -r | tail -n 1 | awk '{first=$1; $1=""; print $0; }' | \
        sed 's/^ //g'
    }
    
    echo "alias "$2"='$(_cralias)'" >> "$file";
    echo "Alias "$2" created for $(_cralias)"
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
    -a|searchall) _search "$@"; . "$file";;
    -c|command) _command "$@"; . "$file";;
  esac
}