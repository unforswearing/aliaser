[![Build Status](https://github.com/unforswearing/aliaser/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/unforswearing/aliaser/actions/workflows/shellcheck.yml)

# aliaser

> `aliaser` is a self-editing alias management tool.

## About

This tool was created to manage persistent aliases when using `bash` or `zsh` interactively.

`aliaser` consists of a single bash function that stores its own aliases. Each alias crated with `aliaser` is appended to the [bottom of the `aliaser.sh` script itself](aliaser.sh#L178). When you source `aliaser.sh` you add the `aliaser` function, and all of the aliases created with this function, to your environment. Please see [aliaser.sh](aliaser.sh) to see how this works.

> [!IMPORTANT]
> `aliaser` is written in `bash`, tested interactively in `zsh` on MacOS and passes most `shellcheck` tests. This script has not been tested on any Linux-based systems.

## Installation

Clone this repo and source `aliaser/aliaser.sh` to get started.

```console
$ git clone https://github.com/unforswearing/aliaser.git .
$ source aliaser.sh
$ aliaser help
```

For persistent use you may source `aliaser` from your `.bashrc`, `.zshrc`, or other shell configuration files. The `aliaser` script must know its own location, so be sure to set up the `ALIASER_SOURCE` environment variable so that it points to `aliaser.sh`.

```bash
# in your $dotfiles:
export ALIASER_SOURCE="path/to/aliaser/aliaser.sh"
source "$ALIASER_SOURCE"
```

## Dependencies

`aliaser` will warn you if either or both of these tools are not found in your environment:

- [`fzf`](https://github.com/junegunn/fzf)
- [`gnu-sed`](https://www.gnu.org/software/sed/) (as `gsed` on MacOS)

## Usage

Typing `aliaser help` prints  help documentation, including the following list of options:

```
Options:
    help      display this help message
    list      list aliases saved in alias file
    dir       create an alias with 'name' that will cd to 'path'
    lastcmd   create an alias from the previous command in your history
    edit      edit alias file in ${EDITOR}
    search    search aliases, select and print matches
    open      open the 'aliaser.sh' script in ${EDITOR}
    clearall  remove all aliases from this alias file
```

### Adding aliases

Aliases can be added to the `aliaser.sh` script using the folling commands:

#### Create an alias that will navigate to the provided path when executed using 'name'.

```
aliaser dir <name> <path>
```

#### Create an alias from the last command in your shell history.

```
aliaser lastcmd <name>
```

#### Create an alias without an option flag

Running `aliaser` without an option flag will allow you to save aliases to this script in a slightly more traditional manner:

```
aliaser <name='command'>
```

Double quote the entire argument to ensure your aliases are not mangled by the script.

```console
aliaser "cd_home_ls='cd $HOME && ls'"
```

### Listing and searching for aliases

Use `aliaser list` to print a list of the aliases currently stored in the script.

The `aliaser search <query>` command will allow you to search your aliases for items matchin `query`. `aliaser` will print the result of the search, or a warning if no match was found. If there is more than one search result, `aliaser` will use `fzf` to let you select between the available matches.

### Editing and removing aliases

The `aliaser edit` command can be used to add new aliases manually, or remove aliases from your list. This is especially useful if you would like to enter multiple aliases at once.

`aliaser` does not have a builtin command to remove individual aliases from the list. Please use `aliaser edit` to modify individual entries. You may use `aliaser clearall` to remove all aliases from the list.

### Debugging and modifications

If you find that an alias has been accidentally mangled, use the `aliaser edit` command to modify any alias stored in the script. You may also use `aliaser open` to modify the `aliaser.sh` script directly, debug your aliases, or improve the code.

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

See [TODO.md](TODO.md)


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
