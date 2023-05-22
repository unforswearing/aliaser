local config = {}
-- user root
config["home_dir"] = "/Users/unforswearing/"
-- project root
local config_home = config["home_dir"]
config["aliaser_root"] = config_home .. "Documents/__Github/aliaser/"
-- runtime files
local aliaser_root = config["aliaser_root"]
-- config["alias_path"] = aliaser_root .. "aliases.lua"
config["alias_path"] = "lua/aliases.lua"
config["script"] = aliaser_root .. "aliaser.lua"
config["self"] = aliaser_root .. "config.lua"

return config
