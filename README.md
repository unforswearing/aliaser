[![Build Status](https://github.com/unforswearing/aliaser/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/unforswearing/aliaser/actions/workflows/shellcheck.yml)

# aliaser

> `aliaser` is a self-editing alias management tool.

`aliaser` consists of a single bash function that stores aliases inside the script file itself. Take a look at [aliaser.sh](aliaser.sh) to see how this works -- aliases are stored at the bottom of the script file.

`aliaser` is written in `bash`, tested interactively in `zsh` and passes most `shellcheck` tests.

## Installation

Clone this repo and source `aliaser/aliaser.sh` to get started.

```bash
$ git clone https://github.com/unforswearing/aliaser.git .
$ source aliaser.sh
$ aliaser help
```

For persistent use you may source `aliaser` from your `.bashrc`, `.zshrc` or other shell configuration files. The `aliaser` script must know its own location, so be sure to set up the `ALIASER_SOURCE` environment variable so that it points to `aliaser.sh`.

```bash
# in your $dotfiles:
export ALIASER_SOURCE="path/to/aliaser/aliaser.sh"
source "$ALIASER_SOURCE"
```

## Usage

Typing `aliaser help` prints  help documentation, including the following list of options:

```
Options:
    help      display this help message
    list      list aliases saved in alias file
    dir       create an alias to cd to a directory with a nickname
    lastcmd   create an alias from the previous command in your history
    edit      edit alias file in ${EDITOR}
    search    search alias file and execute selection
    open      open the 'aliaser.sh' script in ${EDITOR}
    clearall  remove all aliases from this alias file
```

Running 'aliaser' without an option flag will allow you to save aliases to this script in a slightly more traditional manner:

```bash
# note: the entire alias must be quoted
aliaser "cd_home_ls='cd $HOME && ls'"
```

`aliaser` has some example aliases stored at the bottom of the script to show how `aliaser` stores aliases. Run `aliaser clearall` to remove these examples before adding your own aliases.

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
- [ ] Add a method to back up the aliaser script
    - May not be necessary: `aliaser list > aliases.sh`
- [ ] Add a way to create temporary aliases
    - Just use the default `alias` command?
