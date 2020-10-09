import argparse
import os
import sys

if len(sys.argv) > 3:
  print("aliaser only accepts one argument")
  print("use 'aliaser --help' to view options")
  sys.exit()

### CONFIG ----------------------
def readfile(file_path):
  with open(file_path, "r+") as file:
    return file.read()

# check if aliaser dir exists, if not, create it
# i think os.path.join() would make this cross-platform?
aliaser_dir = os.path.join(os.path.expanduser("~"), ".aliaser")
aliaser_config = os.path.join(aliaser_dir, "aliaser.conf")
aliaser_filepath = os.path.join(aliaser_dir,  "aliaser.txt")

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

aliaser_config = readfile(aliaser_config).split("=")[-1]

### ARGS -------------------------

# def main():
# maybe user argparse to get rid of the large help_text function
# cut the first two items out of sys.argv
parser_desc = "aliaser: an alias management / directory navigation tool"
parser = argparse.ArgumentParser(description=parser_desc)

help_text = {
  "list": "list aliases saved in alias file",
  "search":"search alias file and execute selection",
  "edit":"edit alias file in $EDITOR",
  "dir":"create an alias from the current directory (basename)",
  "remove":"remove alias from alias file",
  "name":"create an alias from the current directory with a user defined name",
  "command":"create an alias from the previous command with a user defined name"
}

parser.add_argument("-l", "--list", help=help_text["list"], action="store_const", const="")
parser.add_argument("-s", "--search", help=help_text["search"], action="store_const", const="")
parser.add_argument("-e", "--edit", help=help_text["edit"], action="store_const", const="")
parser.add_argument("-d", "--dir", help=help_text["dir"], action="store_const", const="")
parser.add_argument("-r", "--remove", help=help_text["remove"], metavar="ALIAS_NAME")
parser.add_argument("-n", "--name", help=help_text["name"], metavar="ALIAS_NAME")
parser.add_argument("-c", "--command", help=help_text["command"], metavar="ALIAS_NAME")

# Namespace(command=None, dir=None, edit=None, list=None, name=None, remove='aliasname', search=None)
# use as args.remove, args.name, etc
args = parser.parse_args().__dict__

### EXECUTOR FUNCTIONS ----------

def print_list(_):
  tmp_file = open(aliaser_filepath, "r")
  tmp_contents = tmp_file.read()

  print(tmp_contents)
  tmp_file.close()
  sys.exit()

def search_list(_):
  print("search")

def edit_list(_):
  editor = os.environ["EDITOR"]
  os.system(f"{editor} {aliaser_filepath}")

  sys.exit()

get_current_dir = lambda:os.getcwd()
get_basename = lambda x:get_current_dir(x)

def dir_alias(_):
  current_dir = get_current_dir()
  folder_name = get_basename(current_dir)

  if _ != None: folder_name = _

  composed = f"alias {folder_name}='cd {current_dir}'"

  tmp_file = open(aliaser_filepath, "a")
  tmp_file.write(composed)
  tmp_file.close()

  os.system(f"source {aliaser_filepath}")

  sys.exit()

def remove_alias(alias_name):
  tmp_file = open(aliaser_filepath, "r")
  contents = tmp_file.readlines()

  with open(aliaser_filepath, "w") as tmp:
    for line in contents:
      if f"{alias_name}=" not in line:
        tmp.write(line)

def name_alias(alias_name):
  dir_alias(alias_name)


def command_alias(alias_name):
  hist = open(os.path.join(os.path.expanduser("~"), ".bash_history"), "r")
  hist_list = hist.readlines()
  prev_command = hist_list[-1]

  composed = f"alias {alias_name}='{prev_command}'"

  tmp_file = open(aliaser_filepath, "w")
  tmp_file.write(composed)
  tmp_file.close()

  sys.exit()

for o in args.keys():
  """
  Namespace(command=None, dir=None, edit=None, list=None,
            name=None, remove='aliasname', search=None)
  """

  executor = {
    "list":"print_list",
    "search":"search_list",
    "edit":"edit_list",
    "dir":"dir_alias",
    "remove":"remove_alias",
    "name":"name_alias",
    "command":"command_alias"
  }

  if args[o] != None:
    runner = executor[o]
    globals()[runner](args[o])
    break

### ----------------------------
sys.exit()
