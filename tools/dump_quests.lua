-- Charge le mod dans le mock (tous mods présents, objets bouchons) et exporte le catalogue en JSON sur stdout.
-- Utilisé par tools/validate_quests.py et tools/gen_docs.py. Usage : luajit tools/dump_quests.lua
local ROOT = (arg[0]:match("^(.*)/tools/dump_quests%.lua$")) or "."
package.path = ROOT .. "/?.lua;" .. package.path
local T = require("tests.harness")
local real_stdout = io.write
io.write = function() end   -- silence pendant le chargement
local env = T.env({ all_mods = true, all_items = true, ui = true })
io.write = real_stdout
local Q = env.Q
local out = { version = Q.version, parts = {}, chapters = {}, quests = {}, graph_problems = Q.graph.problems }
for _, p in ipairs(Q.part_list) do
	out.parts[#out.parts + 1] = { id = p.id, numeral = p.numeral, title = p.title, subtitle = p.subtitle,
		illustration = p.illustration }
end
for _, c in ipairs(Q.chapter_list) do
	local L = Q.graph.layout(c.id)
	out.chapters[#out.chapters + 1] = { id = c.id, part = c.part, number = c.number, title = c.title,
		intro = c.intro, icon = c.icon, emblem = c.emblem, cols = L.cols, rows = L.rows }
end
for _, q in ipairs(Q.quest_list) do
	local t = q.trigger
	out.quests[#out.quests + 1] = {
		id = q.id, chapter = q.chapter, title = q.title, description = q.description, objective = q.objective,
		hint = q.hint, icon = q.icon, difficulty = q.difficulty, final = q.final, requires = q.requires,
		mods = q.mods, reward_items = q.reward.items, reward_title = q.reward.title,
		trigger = { type = t.type, items = t.items, groups = t.groups, key = t.key, count = t.count,
			distinct = t.distinct },
		unavailable = q.unavailable,
	}
end
io.write(core.write_json(out), "\n")
