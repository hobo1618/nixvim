local M = {}

function M.run()
	-- Run the shell command and capture the output
	local output = require("ryuvim.utils").run_shell("redis-cli GRAPH.LIST")

	-- Split the output into lines and store them in a table
	local db_list = {}
	for line in output:gmatch("[^\r\n]+") do
		table.insert(db_list, line)
	end

	return db_list -- Return the table of database names
end

return M
