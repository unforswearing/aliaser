-- https://github.com/swarn/fzy-lua
local fzy = require "fzy"
-- https://stevedonovan.github.io/Penlight
local file = require "pl.file"
local pretty = require "pl.pretty"
-- https://stevedonovan.github.io/Penlight/api/libraries/pl.utils.html
local putils = require "pl.utils"
-- require "aliases" -- global var name 'A'
require "config"  -- global var name 'config'

--[[
=== TO DO ===

## options
  - [x] create dir alias
  - [x] create command alias
  - [x] list aliases
  - [x] edit alias file in $EDITOR
  - [x] pwd alias
  - [x] named pwd alias
  - [x] search aliases and print match(es)
  - [x] search aliases and execute selection
  - [ ] search all aliases and exec selection
  - [ ] remove aliases
## plumbing
  - [ ] workflow: create config on first run
  - [ ] workflow: save new file path to config
  - [ ] workflow: read and parse config file
  - [ ] parse script args
  - [ ] error check / assert
  --]]

  --[[
    values = {
      data.name,
      data.path,
      append_type -- dir_alias or command_alias
    }
  --]]

template = {
  source_file = function (values)
    local t = {
      "alias ", values.name, "='", values.command, "'"
    }
    return table.concat(t, "")
  end,
  saved_alias = function (name, command)
    local m = {
      "'"..command.."'",
      "saved as",
      "alias '"..name.."'"
    }
    return table.concat(m, " ")
  end
}

util = {
  pretty_read = pretty.read,
  pretty_dump = pretty.dump,
  file_read = file.read
}

-- load aliases.lua
local alias_path = config.alias_path
local filestring = util.file_read(alias_path)
local A = util.pretty_read(filestring)

function get_system_aliases()
  local aliasfile = "/tmp/aliases"
--  local aliaslist = util.file_read(aliasfile)
  os.execute("cat "..aliasfile.." | fzf")
  -- do something else?
end
get_system_aliases()

function open_config_in_editor()
  os.execute("$EDITOR "..alias_path)
  -- lua how to determine current shell
  -- or just "eval" the alias file somehow?
  os.execute("exec zsh")
  print("shell reloaded")
end
-- open_config_in_editor()

function print_formatted_aliases()
  -- iterate over list A from aliases.lua
  for _name, _command in pairs(A) do
    formatted_alias = template.source_file{
      name = _name,
      command = _command
    }
    print(formatted_alias)
  end
end
-- print_formatted_aliases()

function append_alias(data)
  -- this will need to be changed to use aliases.lua
  local ts = template.saved_alias
  A[data.name] = data.command
  local tmpl = template.source_file{
    name = data.name,
    command = data.command
  }
  util.pretty_dump(A, alias_path)
  print(ts{data.name, data.command})
end
-- append_alias{name = "testington", command = "echo command"}

-- append_current_dir()
function append_current_dir(dirname)
  local _command = table.concat(
    {"cd", path.currentdir()}, " "
  )
  if not dirname then
    local _name = path.basename(path.currentdir())
  else
    local _name = dirname
  end
  append_alias{
    name = _name,
    command = _command
  }
end

function filter_aliases(search_name)
  local ts = template.source_file
  local found_commands = {}
  for _name, _command in pairs(A) do
    -- if _name == search_name then
    if fzy.has_match(search_name, _name) then
      table.insert(found_commands, _command)
      print(ts{ name = _name, command = _command })
    end
  end
  if found_commands and #found_commands == 1 then
    os.execute(found_commands[1])
  else if #found_commands > 1 then
    print(#found_commands.." matching commands. cannot execute.")
  end
  end
  return found_commands
end
-- filter_aliases("lsprojects")

function search_and_exec_aliases(search_name)

end