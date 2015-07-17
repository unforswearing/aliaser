#!/bin/sh
{
set -eo pipefail
IFS=$'\n\t'

helpp ()
{
	cat <<EOF
aliaser [option] [alias name]

options:
	-s, search [search term]     search aliases
	-l, ls, list                 list all aliases
	-r, rm,remove [alias name]   remove an alias
	-d, wd, dir                  make alias name from current working directory
	-o, open                     view the aliaser file in Finder
	-e, edit                     edit alias.txt in EDITOR (or default application)
	-h, help                     print this help text and exit

be sure to source the alias file in your .bashrc or .bash_profile
	'echo \"source ~/.aliaser/alias.txt\" >> ~/.bash_profile'
EOF
exit 1
}

mkdir -p ~/.aliaser || exit 1;

case "$1" in 
	-h|--help|help) helpp;;
	-o|open) open ~/.aliaser; exit 1;;
	-l|ls|list) sort -d ~/.aliaser/alias.txt; exit 1;;
	-e|edit) if [[ "$EDITOR" =~ ^[a-z] ]]; then
    			"$EDITOR" ~/.aliaser/alias.txt;
 		     else 
    			echo "EDITOR not set. Opening with default app..."; 
    			open ~/.aliaser/alias.txt;
				. ~/.aliaser/alias.txt
 		     fi
			 exit 1
	;;
	-r|rm|remove) grep -i -v "$2" ~/.aliaser/alias.txt > mktmp.txt;
		          cat mktmp.txt > ~/.aliaser/alias.txt;
		          rm mktmp.txt;
		          echo "alias \""$2"\" removed";
		          . ~/.aliaser/alias.txt;
				  exit 1
	;;
	-d|wd|dir) name=$(basename $(pwd))
		 	   dir=$(pwd|sed 's/ /\\ /')
			   echo "alias $name='cd $dir'" >> ~/.aliaser/alias.txt;
			   echo "alias \"$name\" created for $(pwd)";
			   . ~/.aliaser/alias.txt;	
			   exit 1	
	;; 
	-s|search) if [[ "$2" == "" ]]; then
     			  echo "aliaser search needs an alias name to search for";
  			   else
    			   grep -i "$2" ~/.aliaser/alias.txt;
				   . ~/.aliaser/alias.txt
  			   fi;
			   exit 1
	;;
esac

if [[ "$1" == "" ]]; then
	echo "aliaser needs an alias name. type 'aliaser help' to view the available commands";
elif [[ "$1" =~ ^-([a-c]|[f-g]|[i-k]|[m-n]|[p-r]|[t-z]) ]]; then
   echo "alias name is not valid. Please do not use '-' before alias names.";
   exit 1;
elif [[ "$1" =~ ([--.]|[\(.]|[\).]|[\/.]|[\\.]|[\..]|[\=.]|[\+.]|[\{.]|[\}.]|[\".]|[\?.]|[\,.]|[\,.]|[\<.]|[\>.]) ]]; then
   echo "alias name is not valid. Please do not use '$(echo "$1" | sed 's/[^[:punct:]]//g')' in alias names.";
   exit 1;
else
	echo "alias "$1"='cd $(pwd|sed 's/ /\\ /')'" >> ~/.aliaser/alias.txt;
    echo "alias \""$1"\" created for $(pwd)";
	. ~/.aliaser/alias.txt;
fi
}
