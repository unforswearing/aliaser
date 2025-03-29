# aliaser

> `aliaser` is a self-editing config-free alias management tool.

`aliaser` consists of a single bash function that stores aliases inside the script file itself. Take a look at [aliaser.sh](aliaser.sh) to see how this works -- aliases are stored at the bottom of the script file.

`aliaser` is written in `bash`, tested interactively in `zsh` and passes most `shellcheck` tests.

## Installation

Clone this repo, move `aliaser` to live with your dotfiles (or wherever you prefer), and source `aliaser/aliaser.sh` to get started.

```bash
$ git clone https://github.com/unforswearing/aliaser.git .
$ source aliaser.sh
$ aliaser help
```

For persistent use you may source `aliaser` from your `.bashrc`, `.zshrc` or other shell configuration files.

```bash
# in your $dotfiles:
export ALIASER_SOURCE="path/to/aliaser/aliaser.sh"
source "$ALIASER_SOURCE"
```

## Usage

Typing `aliaser help` prints  help documentation, including the following list of options:

```
Options:
  help     display this help message
  open     open the alias file with the default gui editor (e.g. TextEdit)
  list     list aliases saved in alias file
  edit     edit alias file in ${EDITOR}
  dir      create an alias from the current directory (alias name is basename)
  lastcmd  create an alias from the previous command in your history
  search   search alias file and execute selection
```

## Examples

### Create an alias from the current dir

```cmd
$ aliaser dir "project_dir" "$HOME/projects"

Added: alias 'project_dir':
  > cd "/Users/unforswearing/projects"
```

### Create an alias from the last command in your history

```cmd
$ sleep 2 && echo awake

awake

$ aliaser lastcmd "wakeup"

Added: alias 'wakeup':
  > "sleep 2 && echo awake"
```

## To Do

- [ ] Add some sort of error checking.
