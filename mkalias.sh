#!/bin/sh

mkalias ()
{

  helpp ()
    {
      echo -e "mkalias [alias name]"
      echo -e "mkalias [option]"
      echo -e ""
      echo -e "options:"
      echo -e "    search [search term]    search aliases"
      echo -e "    ls                      list all aliases"
      echo -e "    rm [alias name]         remove an alias"
      echo -e "    wd                      make alias using current working directory"
      echo -e "    open                    view the mkalias file in Finder"
      echo -e ""
      echo -e "be sure to source the alias file in your .bashrc or .bash_profile"
      echo -e "    'echo \"source ~/.mkalias/alias.txt\" >> ~/.bash_profile'"
    }

    mkdir -p ~/.mkalias || exit 1;

    if [[ "$1" != "$(echo $1 | sed 's/[^A-Za-z0-9_-]//g')" ]]; then
      echo "name is not valid.";
    elif [[ "$1" == "" ]]; then
      echo "mkalias needs an alias name. type 'mkalias help' to view the available commands";
    elif [[ "$1" == "open" ]]; then
      open ~/.mkalias
    elif [[ "$1" == "ls" ]]; then
      sort -d ~/.mkalias/alias.txt;
    elif [[ "$1" == "rm" ]]; then
      grep -i -v "$2" ~/.mkalias/alias.txt > mktmp.txt;
      cat mktmp.txt > ~/.mkalias/alias.txt;
      rm mktmp.txt;
      echo "alias \""$2"\" removed";
      . ~/.mkalias/alias.txt;
    elif [[ "$1" == "wd" ]]; then
      name=$(basename $(pwd)); dir=$(pwd)
      echo "alias $name='cd $dir'" >> ~/.mkalias/alias.txt;
      echo "alias \"$name\" created for $(pwd)";
      . ~/.mkalias/alias.txt;
    elif [[ "$1" == "search" ]]; then
      if [[ "$2" == "" ]]; then
        echo "mkalias search needs an alias name to search for";
      else
        grep -i "$2" ~/.mkalias/alias.txt;
      fi;
    elif [[ "$1" == "help" ]]; then
      helpp;
    else
      echo "alias "$1"='cd $(pwd|sed 's/ /\\/')'" >> ~/.mkalias/alias.txt;
      echo "alias \""$1"\" created for $(pwd)";
      . ~/.mkalias/alias.txt;
    fi
}
