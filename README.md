# aliaser

> An alias management / directory navigation tool.

<details>
<summary>Demo</summary>
<img src="https://raw.githubusercontent.com/unforswearing/aliaser/master/aliaser-example-new.gif">
</details>

<br>

> *Aliaser will soon be rewritten in Python for fun*

## Installation

Aliaser is a single bash function, so you can clone / download this repo and source the file directly:

```bash
$ git clone https://github.com/unforswearing/aliaser.git .
$ cd aliaser
$ source aliaser

```

MacOs users can install with Homebrew. This puts aliaser in your $PATH by default (/usr/local/bin/aliaser)

```
$ brew install unforswearing/dist/aliaser
$ source aliaser
```

You may also want to source aliaser in your `bash_profile` or other config. For more information, see the "Running Aliaser" section below.

<br>

## Usage

When `aliaser` is run for the first time it will create a `.aliaser` directory that contains the alias text file. Use `aliaser open` to view the this file in your default `.txt` file editor. You may also use `aliaser edit` to edit this file in your terminal.

Add `source ~/.aliaser/aliaser.txt` to your `bash_profile ` before creating your first alias. Aliases created via `aliaser` are available immediately.

Typing `aliaser help` produces the following help text:

```
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
```

After sourcing `aliaser`, you can navigate to a directory and make some aliases:

```bash
$ cd ~/scripts
$ aliaser -d myscripts
```

Or create an alias for the previously executed command:

```bash
# execute a command command
$ b=1; while [ $b -le 2 ]; do tput flash; sleep .02; b=$((b + 1)); done

# create alias for previously executed command
$ aliaser -c "flash_terminal"
```

`aliaser` will use [`fzf`](https://github.com/junegunn/fzf) if it is installed and in your $PATH. Otherwise, `aliaser` will default to [`listbox`](https://github.com/gko/listbox) which is embedded in the aliaser script.

<br>

