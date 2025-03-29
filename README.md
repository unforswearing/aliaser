[![Build Status](https://github.com/unforswearing/aliaser/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/unforswearing/aliaser/actions/workflows/shellcheck.yml)

# aliaser

> `aliaser` is a self-editing alias management tool.

`aliaser` consists of a single bash function that stores aliases inside the script file itself. Take a look at [aliaser.sh](aliaser.sh) to see how this works -- aliases are stored at the bottom of the script file.

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

### Dependencies

This script relies on `gnu-sed` and is used as `gsed` internally.

> [!IMPORTANT]
> `aliaser` is written in `bash`, tested interactively in `zsh` on MacOS and passes most `shellcheck` tests. `aliaser` has not been tested on any Linux-based systems.

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

## To Do / Roadmap

- [ ] Add some sort of error checking.
    - Error if more args than expected
    - Check exit status
    - Run shellcheck against newly created aliases?
    - Etc?
- [ ] Add method to bulk add new aliases from a file.
    - `aliaser addbulk "bash_aliases.sh"`
- [ ] Add an internal method to update aliaser
    - `aliaser updateself`
      - Curl script from github
      - Check if update is needed (via script version, or etc (TBD))
      - If update needed
          - Export aliases to temporary file
          - Replace aliaser.sh with new version
          - Import aliases to new aliaser.sh script
          - Confirm success
      - If no update needed, confirm script is latest version.
