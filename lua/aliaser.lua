require("sh")
config = require("lua/config")
aliases = require("lua/aliases")

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

function get_alias(name) print(aliases[name]) end

function get_aliaser_aliases()
  for _name, _command in pairs(aliases) do
    print(_name .. "=" .. _command)
  end
end

-- it seems like "sh" uses an very basic shell
-- and I can't load aliases set via ~/.config.zsh

function get_system_aliases()
  -- does not work: os.execute("alias")
  os.execute("alias")
  --[[
    this seems easiest with an environment variable
    `export ALIASES=$(alias)` 
    and then use `os.getenv("ALIASES")` to load 
  --]]
end
