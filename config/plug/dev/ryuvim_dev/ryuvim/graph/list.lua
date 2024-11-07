local M = {}

function M.get_graphs()
	-- Run the shell command and capture the output
	local output = require("ryuvim.utils").run_shell("redis-cli GRAPH.LIST")

	-- Split the output into lines and store them in a table
	local db_list = {}
	for line in output:gmatch("[^\r\n]+") do
		table.insert(db_list, line)
	end

	return db_list -- Return the table of database names
end

function M.list()
	local dbs = M.get_graphs()
	if #dbs == 0 then
		print("No databases found.")
		return
	end

	-- Print each database name
	--
	local content = { "List of Databases:" }
	print()
	for _, db in ipairs(dbs) do
		-- print("- " .. db)
		table.insert(content, "- " .. db)
	end
	require("ryuvim.utils").show_in_float(table.concat(content, "\n"))
end

return M
