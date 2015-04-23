# mkalias  

Another directory traversal tool. Inspired by [bashmarks](https://github.com/huyng/bashmarks), but way less intelligent.  

![gif](https://raw.githubusercontent.com/unforswearing/mkalias/master/mkalias-example.gif)


## Usage  

`cd` to a directory and make some aliases. For example: `cd ~/scripts; mkalias myscripts`

When `mkalias` is run for the first time it will create a `.mkalias` directory that contains the alias text file. Use `mkalias open` to view the this file in Finder. 

Aliases created via `mkalias` are available immediately after creation, meaning no more sourcing your bash profile to get an alias to work. 

More options:  

```
    search [search term]    search aliases
    ls                      list all aliases
    rm [alias name]         remove an alias
    wd                      make alias using current working directory
    open                    view the mkalias file in Finder
```

Type `mkalias help` for the full usage text.  

## Installation  

This script is a function called `mkalias` which can be sourced in your bash profile (as seen in the usage above) or added to your bash profile or anywhere else you keep those types of things. 

## License 

To do what thou wilt shall be the whole of the license. 
