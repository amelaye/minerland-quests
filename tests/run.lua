-- Lanceur des tests simulés.
--   luajit tests/run.lua            -> tous les fichiers tests/test_*.lua
--   luajit tests/run.lua engine ui  -> tests/test_engine.lua et tests/test_ui.lua
local ROOT = (arg[0]:match("^(.*)/tests/run%.lua$")) or "."
package.path = ROOT .. "/?.lua;" .. package.path
local T = require("tests.harness")

local files = {}
if #arg > 0 then
	for _, a in ipairs(arg) do files[#files + 1] = ROOT .. "/tests/test_" .. a .. ".lua" end
else
	local p = io.popen('ls -1 "' .. ROOT .. '/tests" 2>/dev/null')
	for line in p:lines() do
		if line:match("^test_.*%.lua$") then files[#files + 1] = ROOT .. "/tests/" .. line end
	end
	p:close()
	table.sort(files)
end

io.write("Tests SIMULÉS (mock de l'API Luanti, LuaJIT) — ils ne remplacent pas un test dans le moteur réel.\n")
for _, f in ipairs(files) do
	io.write("\n# ", f:match("[^/]+$"), "\n")
	local chunk, err = loadfile(f)
	if not chunk then
		T.results.failed = T.results.failed + 1
		table.insert(T.results.failures, f .. " : " .. tostring(err))
	else
		local ok, e = xpcall(function() chunk(T) end, debug.traceback)
		if not ok then
			T.results.failed = T.results.failed + 1
			table.insert(T.results.failures, f .. " : " .. tostring(e))
		end
	end
end

io.write(("\n%d réussi(s), %d échec(s)\n"):format(T.results.passed, T.results.failed))
for _, f in ipairs(T.results.failures) do io.write("\n--- ÉCHEC : ", f, "\n") end
os.exit(T.results.failed == 0 and 0 or 1)
