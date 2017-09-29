# aliaser

Another directory traversal tool. Inspired by [bashmarks](https://github.com/huyng/bashmarks), but way less intelligent.

![example](https://raw.githubusercontent.com/unforswearing/aliaser/master/aliaser-example.gif)
<br /><br />

## Installation

This script is a function called `aliaser` which can added to your bash profile as an alias or function, or stored anywhere else you keep those types of things. 

```bash
source /path/to/aliaser.bash`  
```

<br>

## Usage

Navigate to a directory and make some aliases: 

```bash
$ cd ~/scripts; aliaser -d myscripts` 
``` 

Or create an alias for a command immediately after execution:  

```bash
# command
$ b=1; while [ $b -le 2 ]; do tput flash; sleep .02; b=$((b + 1)); done 

# create alias for command
$ aliaser -c "flash_terminal"
```

When `aliaser` is run for the first time it will create a `.aliaser` directory that contains the alias text file. Use `aliaser open` to view the this file in Finder.

Add `source ~/.aliaser/aliaser.txt` to your `bash_profile ` before creating your first alias. Aliases created via `aliaser` are available immediately.

More options:

```
aliaser <option> [alias name]

options:
	-s, search [search term]     search aliases
	-l, ls, list                 list all aliases
	-r, rm,remove [alias name]   remove an alias
	-d, wd, dir                  make alias name from current working directory
	-o, open                     view the aliaser file in Finder
	-e, edit                     edit alias.txt in EDITOR (or default application)
	-n, name		     create alias "Name" for "Directory"
	-c, command		     create alias "Name" for "Command"
	-h, help                     print this help text and exit

be sure to source the alias file in your .bashrc or .bash_profile
```

Note that `aliaser search` uses [listbox](https://github.com/gko/listbox) to generate a list of results. `aliaser` will navigate to or execute the selected option. For example:

```
> aliaser search script

  Search results for "script"
  ---------------------------
⇨ alias scripts='cd ~/Documents/Shared/Scripts'
  alias googleappsscript='cd ~/Documents/Shared/Scripts/-GoogleAppsScript'
  alias bashscripts='cd ~/Documents/Shared/Scripts/-Bash'
  CANCEL SEARCH
```

Type `aliaser help` for the full usage text.

<br>

##  Why? 

I continually learn more about `bash` and in the process, found a few interesting was to navigate the shell:  

- `shopt -s autocd`: when set, you simply have to enter the directory name to navigate. The directory you type must be a subdirectory of your current location. 
- `shopt -s cdable_vars`: this command allows you to export variables to easily navigate to your favorite paths. This perhaps is easier in aliaser, as the paths are added to a file you specify with `aliaser -d`, however, this is trivial. 
- `shopt` is also useful for many other things -- [take a look at this page](http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html) if you're unfamiliar.  

<br>

## Bugs

`aliaser` is decently stable at this point, but please get in touch if you experience issues. 

