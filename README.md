# Deprecated

After learning more about `bash` I found that much of the functionality of `aliaser` was built in. In particular, the following commands do exactly what `aliaser` was built for:  

- `shopt -s autocd`: when set, you simply have to enter the directory name to navigate. The directory you type must be a subdirectory of your current location. 
- `shopt -s cdable_vars`: this command allows you to export variables to easily navigate to your favorite paths. This perhaps is easier in aliaser, as the paths are added to a file you specify with `aliaser -d`, however, this is trivial. 

These were my main reasons for writing `aliaser`, so I feel a bit stragely about recreating commands that someone smarter than I thought of a long time ago. Also `shopt` is useful for many other things -- [take a look at this page](http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html) if you're unfamiliar.  

`aliaser` was a fun experiment, and perhaps will see an update or rewrite sometime soon to combine `shopt` integration with the `aliaser -c` and other alias manange ment tasks (I think `aliaser` is a pretty decent alias manager, but not so great alias creator). If you are interested, the latest and (maybe) final update of `aliaser` starts below. 

---

# aliaser

Another directory traversal tool. Inspired by [bashmarks](https://github.com/huyng/bashmarks), but way less intelligent.

![example](https://raw.githubusercontent.com/unforswearing/aliaser/master/aliaser-example.gif)
<br /><br />


## Usage

`cd` to a directory and make some aliases. For example: `cd ~/scripts; aliaser myscripts`

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
		-n, name					 create alias "Name" for "Directory"
		-c, command					 create alias "Name" for "Command"
		-h, help                     print this help text and exit

	be sure to source the alias file in your .bashrc or .bash_profile
```

Type `aliaser help` for the full usage text.

## Installation

This script is a function called `aliaser` which can added to your bash profile as an alias or function, or stored anywhere else you keep those types of things.

## Bugs

There are probably lots. Let me know if you find some.

## License

GNU General Public License v3.0
