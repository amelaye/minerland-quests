-- Configuration luacheck (facultatif : https://github.com/lunarmodules/luacheck)
std = "luajit"
max_line_length = 120
unused_args = false
allow_defined_top = false

globals = { "minerland_quests" }
read_globals = {
	"core", "minetest", "ItemStack", "vector", "dump", "VoxelArea",
	string = { fields = { "split", "trim" } },
	table = { fields = { "copy", "indexof" } },
	-- mods tiers (lecture seule)
	"unified_inventory", "armor", "rings", "default", "farming", "mobs", "technic", "techage",
}
files["tests/"] = { globals = { "core", "minetest", "ItemStack", "minerland_quests", "default", "unified_inventory" } }
files["tools/"] = { globals = { "core", "minetest", "ItemStack", "minerland_quests", "default", "unified_inventory" } }
exclude_files = { ".audit_src/", "dist/" }
