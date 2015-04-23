#!/bin/sh

mkalias ()
{

  helpp ()
    {
       echo -e "mkalias - quickly make aliases for frequently traveled directories"
       printf '\n'
       echo -e "usage:"
       echo -e "  mkalias [<alias name>]	make aliases"
       echo -e "    search [<search term>]	search aliases"
       echo -e "    ls	list all aliases"
       echo -e "    rm	remove an alias"
       echo -e "    wd make alias using current dirname"
       printf '\n'
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
      grep --color=auto -i -v "$2" ~/.mkalias/alias.txt > mktmp.txt;
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
        grep --color=auto -i "$2" ~/.mkalias/alias.txt;
      fi;
    elif [[ "$1" == "help" ]]; then
      helpp;
    else
      echo "alias "$1"='cd $(pwd|sed 's/ /\\/')'" >> ~/.mkalias/alias.txt;
      echo "alias \""$1"\" created for $(pwd)";
      . ~/.mkalias/alias.txt;
    fi
}
