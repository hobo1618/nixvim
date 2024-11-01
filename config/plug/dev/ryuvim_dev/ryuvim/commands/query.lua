-- graph_query.lua
local M = {}

-- Function to execute GRAPH.QUERY
function M.query(graph_name, query, timeout)
	local command = "redis-cli GRAPH.QUERY " .. graph_name .. ' "' .. query .. '"'
	if timeout then
		command = command .. " TIMEOUT " .. timeout
	end

	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()

	return result
end

-- Function to select a database and then run a query
function M.run_query()
	local db_list = require("ryuvim.commands.list").run() -- Fetch the list of databases

	-- Show a selection menu for the databases
	vim.ui.select(db_list, { prompt = "Select a database:" }, function(selected_db)
		if not selected_db then
			print("No database selected. Operation cancelled.")
			return
		end

		-- Prompt the user to enter the query
		local query = vim.fn.input("Enter your query: ")

		if query == "" then
			print("No query entered. Operation cancelled.")
			return
		end

		-- Run the query
		local result = M.query(selected_db, query)
		print("Query Result:\n" .. result)
	end)
end

return M
