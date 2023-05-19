-- https://github.com/swarn/fzy-lua
local fzy = require "fzy"
-- https://stevedonovan.github.io/Penlight
local file = require "pl.file"
local pretty = require "pl.pretty"
-- https://stevedonovan.github.io/Penlight/api/libraries/pl.utils.html
local putils = require "pl.utils"
-- require "aliases" -- global var name 'A'
-- global var name 'config'
local config = require "config"

--[[

@todo use a damn REPL to test these functions
@todo review the structure of the code that has been written
@todo: options
  - [x] create dir alias
  - [x] create command alias
  - [x] list aliases
  - [x] edit alias file in $EDITOR
  - [x] pwd alias
  - [x] named pwd alias
  - [x] search aliases and print match(es)
  - [x] search aliases and execute selection
  - [ ] search all aliases (aliases.lua and os.execute('alias')) and exec selection
  - [ ] remove aliases
@todo: plumbing
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
local template = {
  source_file = function(values)
    local tmpl = {
      "alias ", values.name, "='", values.command, "'"
    }
    return table.concat(tmpl, "")
  end,
  saved_alias = function(name, command)
    local comm = {
      "'" .. command .. "'",
      "saved as",
      "alias '" .. name .. "'"
    }
    return table.concat(comm, " ")
  end
}

local util = {
  pretty_read = pretty.read,
  pretty_dump = pretty.dump,
  file_read = file.read
}

-- load aliases.lua
local alias_path = config.alias_path
local filestring = util.file_read(alias_path)
local ALIASES = util.pretty_read(filestring)

local function get_system_aliases()
  local aliasfile = "/tmp/aliases"
  -- local aliaslist = util.file_read(aliasfile)
  -- local aliaslist = os.execute("alias") ??
  os.execute("cat " .. aliasfile .. " | fzf")
  -- do something else?
end
get_system_aliases()

--[[ local --]]
function open_config_in_editor()
  os.execute("$EDITOR " .. alias_path)
  -- lua how to determine current shell
  -- or just "eval" the alias file somehow?
  os.execute("exec zsh")
  print("shell reloaded")
end

-- open_config_in_editor()

--[[ local --]]
function print_formatted_aliases()
  -- iterate over list ALIASES from aliases.lua
  for _name, _command in pairs(ALIASES) do
    local formatted_alias = template.source_file {
      name = _name,
      command = _command
    }
    print(formatted_alias)
  end
end

-- print_formatted_aliases()

--[[ local --]]
function append_alias(data)
  -- this will need to be changed to use aliases.lua
  local ts = template.saved_alias
  ALIASES[data.name] = data.command
  local tmpl = template.source_file {
    name = data.name,
    command = data.command
  }
  util.pretty_dump(ALIASES, alias_path)
  print(ts { data.name, data.command })
end

-- append_alias{name = "testington", command = "echo command"}

-- append_current_dir()
--[[ local --]]
function append_current_dir(dirname)
  local _command = table.concat(
    { "cd", putils.path.currentdir() }, " "
  )
  local _name
  if not dirname then
    _name = putils.path.basename(putils.path.currentdir())
  else
    _name = dirname
  end
  append_alias {
    name = _name,
    command = _command
  }
end

-- find_alias()
--[[ local --]]
function find_alias(search_name)
  local ts = template.source_file
  for _name, _command in pairs(ALIASES) do
    -- use a regex / glob search to match instead of strict equals
    if _name == search_name then
      print(ts { name = _name, command = _command })
    end
  end
end

-- find_alias("project")

-- find_and_exec_alias()
--[[ local --]]
function find_and_exec_alias(search_name)
  local ts = template.source_file
  local found_commands = {}
  for _name, _command in pairs(ALIASES) do
    -- if _name == search_name then
    if fzy.has_match(search_name, _name) then
      table.insert(found_commands, _command)
      print(ts { name = _name, command = _command })
    end
  end
  if found_commands and #found_commands == 1 then
    os.execute(found_commands[1])
  else
    if #found_commands > 1 then
      print(#found_commands .. " matching commands. cannot execute.")
    end
  end
  return found_commands
end

-- find_and_exec_alias("lsprojects")
