# aliaser

An alias management / directory navigation tool.

<hr>
<img src="https://raw.githubusercontent.com/unforswearing/aliaser/master/aliaser-example-new.gif">
<hr>
<br>

## Installation

```bash
$ git clone https://github.com/unforswearing/aliaser.git aliaser
$ cd aliaser
$ echo "source $(pwd)/aliaser.bash" >> ~/.bash_profile
```

Or download the zip and manually move to whever you store your scripts, dotfiles, or bash functions. 

<br>

## Usage 

Typing `aliaser help` produces the following help text:  

```
aliaser <option> [alias name]

options:
  -h|help         display this help message
  -o|open         open the alias file with the default gui editor (e.g. TextEdit)
  -l|list         list aliases saved in alias file
  -e|edit         edit alias file in /usr/local/bin/micro
  -r|rm           remove alias from alias file
  -d|dir          create an alias from the current directory (alias name is basename)
  -n|name         create an alias with a user defined name
  -s|search       search alias file and execute selection
  -a|searchall    search all aliases system wide and execute selection
  -c|command      create an alias from the previous command with a user defined name

examples:
  aliaser rm "aliasname"      remove alias named "aliasname" from alias file
  aliaser -n "favoritedir"    add an alias named "favoritedir" to alias file


be sure to source the alias file in your .bashrc or .bash_profile
``` 

When `aliaser` is run for the first time it will create a `.aliaser` directory that contains the alias text file. Use `aliaser open` to view the this file in your default `.txt` file editor. You may also use `aliaser edit` to edit this file in your terminal.

Add `source ~/.aliaser/aliaser.txt` to your `bash_profile ` before creating your first alias. Aliases created via `aliaser` are available immediately.

After sourcing `aliaser`, you can navigate to a directory and make some aliases: 

```bash
$ cd ~/scripts; aliaser -d myscripts  
``` 

Or create an alias for a command immediately after execution:  

```bash
  # command
  $ b=1; while [ $b -le 2 ]; do tput flash; sleep .02; b=$((b + 1)); done 

  # create alias for command
  $ aliaser -c "flash_terminal"
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

<br>

##  Why? 

Originally, I wanted to create a script that would allow me to simply type in the directory name (or command alias) to navigate (or execute) without having to remember a list of options aside from those needed to set up the aliases. I believe I was successful, and in the process of creating `aliaser`, I found a few other interesting was to navigate the shell:  

- `shopt -s autocd`: when set, you simply have to enter the directory name to navigate. The directory you type must be a subdirectory of your current location. 
- `shopt -s cdable_vars`: this command allows you to export variables to easily navigate to your favorite paths. This perhaps is easier in aliaser, as the paths are added to a file you specify with `aliaser -d`, however, this is trivial. 
- `shopt` is also useful for many other things -- [take a look at this page](http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html) if you're unfamiliar.  

<br>

## Bugs

`aliaser` is decently stable at this point, but please get in touch if you experience issues. 

`aliaser` has been tested extensively on MacOS, but should work on most Linux distros.

<br>

## To Do  

- [x] Update gif 

