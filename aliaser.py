"""
Aliaser - alias management tool for the command line.

The python version of aliaser is a work in progress and is missing
the 'aliaser --search' command

This script also needs error checking

I also may want to start using a json file for config

Features to add:
- 'aliaser -h <command>' to provide instructions and examples for <command>
- Append to bashrc / bash_profile by default
  - alias files are separate from config, so the script could append
    any file that is sourced when the terminal loads
- Archive aliases on Github or Gitlab (and maybe BitBucket, etc)
- Read aliases from the above services
- User created add-ons that can be written in any language
  - something like 'aliaser --addon "addOn.js" --addon-lang "javascript"'
  - the above would store the script name and location in 'config' for use
  - whenever aliaser runs again --> 'aliaser --run-addon "addOn"'
- Possibly add some terminal navigation tools
  - navigate to a folder n levels up or down a dir tree
  - navigate to a dir based on a pattern / glob
  - etc
"""

import argparse
import os
import sys

# Aliaser arguments are somewhat mutually exclusive, so
# make sure there are only 3 arguments (This could probably
# be improved)
if len(sys.argv) > 3:
    print("aliaser only accepts one argument")
    print("use 'aliaser --help' to view options")
    sys.exit()

# CONFIG ----------------------
# config may change to a json file


def readfile(file_path):
    with open(file_path, "r+") as file:
        return file.read()


# check if aliaser dir exists, if not, create it
# i think os.path.join() would make this cross-platform?
# --> relying on bash history makes script only available on
# MacOs / Linux / maybe WSL (https://docs.microsoft.com/en-us/windows/wsl/about)
aliaser_dir = os.path.join(os.path.expanduser("~"), ".aliaser")
aliaser_config = os.path.join(aliaser_dir, "aliaser.conf")
aliaser_filepath = os.path.join(aliaser_dir,  "aliaser.txt")

# create the directory if it doesn't exist
# ask the user for permission first
if not os.path.isdir(aliaser_dir):
    os.mkdir(aliaser_dir)

    print("Enter the location of your alias file, or press enter to use the default")
    file_location = input(f"(default - {aliaser_filepath}: ")

    if not file_location:
        file_location = aliaser_filepath

    # open the alias.txt file
    with open(aliaser_config, "w+") as file:
        file.write(f"alias_file={file_location}")
        file.close()

# get the contents of the aliaser config file
aliaser_config = readfile(aliaser_config).split("=")[-1]

# ARGS -------------------------

# def main():
parser_desc = "aliaser: an alias management / directory navigation tool"
parser = argparse.ArgumentParser(description=parser_desc)

help_text = {
    "list": "list aliases saved in alias file",
    "search": "search alias file and execute selection",
    "edit": "edit alias file in $EDITOR",
    "dir": "create an alias from the current directory (basename)",
    "remove": "remove alias from alias file",
    "name": "create an alias from the current directory with a user defined name",
    "command": "create an alias from the previous command with a user defined name"
}

parser.add_argument(
    "-l", "--list", help=help_text["list"], action="store_const", const="")
parser.add_argument(
    "-s", "--search", help=help_text["search"], action="store_const", const="")
parser.add_argument(
    "-e", "--edit", help=help_text["edit"], action="store_const", const="")
parser.add_argument(
    "-d", "--dir", help=help_text["dir"], action="store_const", const="")
parser.add_argument(
    "-r", "--remove", help=help_text["remove"], metavar="ALIAS_NAME")
parser.add_argument(
    "-n", "--name", help=help_text["name"], metavar="ALIAS_NAME")
parser.add_argument("-c", "--command",
                    help=help_text["command"], metavar="ALIAS_NAME")

# Namespace(command=None, dir=None, edit=None, list=None, name=None, remove='aliasname', search=None)
# use as args.remove, args.name, etc
args = parser.parse_args().__dict__

# EXECUTOR FUNCTIONS ----------
# -l / --list


def print_list(_):
    tmp_file = open(aliaser_filepath, "r")
    tmp_contents = tmp_file.read()

    print(tmp_contents)
    tmp_file.close()
    sys.exit()

# -e / --edit


def edit_list(_):
    editor = os.environ["EDITOR"]
    os.system(f"{editor} {aliaser_filepath}")

    sys.exit()

# -s / --search


def search_list(alias_name):
    """
    https://www.devdungeon.com/content/curses-programming-python
    - find alias_name in aliaser.txt
    - if there is more than one result, present a list of options
      - fzf would be nice, but I want this script to have no libraries
    - if found, ask to execute
    - exit script
    """
    pass

# -d / --dir


def dir_alias(_):
    current_dir = os.getcwd()
    folder_name = os.path.basename(current_dir)

    if _ != None:
        folder_name = _

    composed = f"alias {folder_name}='cd {current_dir}'"

    tmp_file = open(aliaser_filepath, "a")
    tmp_file.write(composed)
    tmp_file.close()

    os.system(f"source {aliaser_filepath}")

    sys.exit()

# -r / --remove


def remove_alias(alias_name):
    tmp_file = open(aliaser_filepath, "r")
    contents = tmp_file.readlines()

    with open(aliaser_filepath, "w") as tmp:
        for line in contents:
            if f"{alias_name}=" not in line:
                tmp.write(line)

# -n / --name


def name_alias(alias_name):
    dir_alias(alias_name)

# -c / --command


def command_alias(alias_name):
    hist = open(os.path.join(os.path.expanduser("~"), ".bash_history"), "r")
    hist_list = hist.readlines()
    prev_command = hist_list[-1]

    composed = f"alias {alias_name}='{prev_command}'"

    tmp_file = open(aliaser_filepath, "w")
    tmp_file.write(composed)
    tmp_file.close()

    sys.exit()


# This needs work
# loop through args to extract options
for o in args.keys():
    """
    Namespace(command=None, dir=None, edit=None, list=None,
              name=None, remove='aliasname', search=None)
    """

    executor = {
        "list": "print_list",
        "search": "search_list",
        "edit": "edit_list",
        "dir": "dir_alias",
        "remove": "remove_alias",
        "name": "name_alias",
        "command": "command_alias"
    }

    if args[o] != None:
        runner = executor[o]
        globals()[runner](args[o])
        break

# ----------------------------
sys.exit()
