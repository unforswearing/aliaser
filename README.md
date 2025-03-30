[![Build Status](https://github.com/unforswearing/aliaser/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/unforswearing/aliaser/actions/workflows/shellcheck.yml)

# aliaser

> `aliaser` is a self-editing alias management tool.

`aliaser` consists of a single bash function that stores aliases inside the script file itself. Take a look at [aliaser.sh](aliaser.sh) to see how this works -- aliases are stored at the bottom of the script file.

## Installation

Clone this repo and source `aliaser/aliaser.sh` to get started.

```console
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

## Dependencies

> [!IMPORTANT]
> `aliaser` is written in `bash`, tested interactively in `zsh` on MacOS and passes most `shellcheck` tests. This script has not been tested on any Linux-based systems.

`aliaser` will warn you if either or both of these tools are not found in your environment:

- [`fzf`](https://github.com/junegunn/fzf)
- [`gnu-sed`](https://www.gnu.org/software/sed/)

## Usage

Typing `aliaser help` prints  help documentation, including the following list of options:

```
Options:
    help      display this help message
    list      list aliases saved in alias file
    dir       create an alias with 'name' that will cd to 'path'
    lastcmd   create an alias from the previous command in your history
    edit      edit alias file in ${EDITOR}
    search    search aliases, print and select matches
    open      open the 'aliaser.sh' script in ${EDITOR}
    clearall  remove all aliases from this alias file
```

### Running `aliaser` without an option flag

Running `aliaser` without an option flag will allow you to save aliases to this script in a slightly more traditional manner:

```console
# note: the entire alias must be quoted
aliaser "cd_home_ls='cd $HOME && ls'"
```

### Editing aliases and the `aliaser.sh` script

If find that an alias has been accidentally mangled, use `aliaser edit` to modify your aliases. You may also use `aliaser open` to modify the `aliaser.sh` script directly, debug your aliases, or improve the code.

## Examples

`aliaser` has some example aliases stored at the bottom of the script to show how `aliaser` stores aliases. Run `aliaser clearall` to remove these examples before adding your own aliases.

### Create an alias from the current dir

```console
$ aliaser dir "project_dir" "$HOME/projects"

Added: alias 'project_dir':
  > cd "/Users/unforswearing/projects"
```

### Create an alias from the last command in your history

```console
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


<!--
### Search for an alias and use the matching command in a script

In your terminal:

```console
$ shfmt -i 2
$ aliaser lastcmd "format"
```

Use the `format` alias in a script:

```bash
# new_script.sh
source aliaser.sh

# use 'format'
"$EDITOR" ./build.sh
build_formatted=$(aliaser search "format" "./build.sh")
```
-->
