# aliaser  

Another directory traversal tool. Inspired by [bashmarks](https://github.com/huyng/bashmarks), but way less intelligent.  

## Usage  

`cd` to a directory and make some aliases. For example: `cd ~/scripts; aliaser myscripts`

When `aliaser` is run for the first time it will create a `.aliaser` directory that contains the alias text file. Use `aliaser open` to view the this file in Finder. 

Add `source ~/.aliaser/aliaser.txt` to your `bash_profile ` before creating your first alias. Aliases created via `aliaser` are available immediately. 

More options:  

```
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
```

Type `aliaser help` for the full usage text.  

## Installation  

This script is a function called `aliaser` which can added to your bash profile as an alias or function, or stored anywhere else you keep those types of things. 

## License 

MIT
