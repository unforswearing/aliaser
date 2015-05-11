# mkalias  

Another directory traversal tool. Inspired by [bashmarks](https://github.com/huyng/bashmarks), but way less intelligent.  

![gif](https://raw.githubusercontent.com/unforswearing/mkalias/master/mkalias-example.gif)


## Usage  

`cd` to a directory and make some aliases. For example: `cd ~/scripts; mkalias myscripts`

When `mkalias` is run for the first time it will create a `.mkalias` directory that contains the alias text file. Use `mkalias open` to view the this file in Finder. 

Add `source ~/.mkalias/mkalias.txt` to your `bash_profile ` before creating your first alias. Aliases created via `mkalias` are available immediately. 

More options:  

```
mkalias
        search [search term]    search aliases
        ls                      list all aliases
        rm [alias name]         remove an alias
        wd                      make alias name from current working directory
        open                    view the mkalias file in Finder
```

Type `mkalias help` for the full usage text.  

## Installation  

This script is a function called `mkalias` which can added to your bash profile as an alias or function, or stored anywhere else you keep those types of things. 

## License 

MIT
