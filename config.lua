config = {}
-- user root
config["home_dir"] = "/Users/unforswearing/"
-- project root
local ch = config["home_dir"]
config["aliaser_root"] = ch.."Documents/__Github/aliaser/"
-- runtime files
local ar = config["aliaser_root"]
config["alias_path"] = ar.. "aliases.lua"
config["script"] = ar.."aliaser.lua"
config["self"] = ar.."config.lua"