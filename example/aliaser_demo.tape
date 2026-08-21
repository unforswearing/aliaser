Output aliaser_demo.gif

Set Height 1000
Set Width 1600

Type "# a simple example of using aliaser"
Enter
Sleep 3s
Type "# first we source aliaser from the parent directory"
Enter
Sleep 1s
Type "source ../aliaser.sh"
Enter
Sleep 3s
Type "# typing `aliaser help` will show a list of available commands"
Enter
Type "aliaser help"
Enter
Sleep 5s
Ctrl+L
Type "# now lets run through an example"
Enter
Sleep 1s
Type "# use the `aliaser list` command to see all of your aliases."
Enter
Sleep 1s
Type "aliaser list"
Enter
Sleep 1s
Type "# lets get rid of these aliases for this demo."
Enter
Type "# the `aliaser clearall` command will remove them for us."
Enter
Sleep 1s
Type "aliaser clearall"
Enter
Sleep 3s
Ctrl+L
Type "# lets use the `aliaser dir` command to easily navigate to our 'files' directory."
Enter
Sleep 1s
Type "aliaser dir filedir files"
Enter
Sleep 3s
Type "# lets visit our 'files' directory using the alias named 'filedir' that we just created."
Enter
Type "filedir && ls"
Enter
Sleep 5s
Type "# done. find more at github.com/unforswearing/aliaser"
Enter
Sleep 8s

