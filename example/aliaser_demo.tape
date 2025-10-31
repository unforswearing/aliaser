Output aliaser_demo.gif

Set Height 1000
Set Width 1600

Type "# A simple example of sourcing and using aliaser."
Sleep 500ms
Enter
Sleep 2s

Type "# First, we source aliaser."
Enter
Type "# In this example, aliaser lives in the parent directory."
Enter
Type "source ../aliaser.sh"
Sleep 500ms
Enter
Sleep 4s

Type `# FYI - aliaser will use the value of `
Enter
Type `$EDITOR for 'open' and 'edit' commands.`
Enter
Type `echo "editor = $EDITOR"`
Enter
Sleep 4s


Type `# Typing 'aliaser help' will print a list of available commands.`
Type "aliaser help"
Sleep 500ms
Enter
Sleep 4s

Hide
Type "aliaser clearall"
Enter
Show

Type "# Now, let's run through a few quick examples."
Sleep 500ms
Enter
Sleep 4s

Ctrl+L

Type "aliaser"
Sleep 500ms
Enter
Sleep 2s
Type "aliaser list"
Sleep 500ms
Enter
Sleep 2s

Ctrl+L

Type `aliaser "sayhi='echo hello'"`
Sleep 500ms
Enter
Sleep 4s
Type "sayhi"
Sleep 500ms
Enter
Sleep 4s

Type "aliaser list"
Sleep 500ms
Enter
Sleep 8s

Ctrl+L

Type "# Done. Find more at github.com/unforswearing/aliaser"
Sleep 500ms
Enter
Sleep 8s

