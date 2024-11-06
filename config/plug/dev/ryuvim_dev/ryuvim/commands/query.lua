local M = {}
local set_db = require("ryuvim.commands.set_db") -- Import the set_db module

-- Function to execute GRAPH.QUERY
function M.query(query, timeout)
	-- Use the active_db from set_db
	local graph_name = set_db.active_db
	print(graph_name)

	-- Ensure a database is selected
	if not graph_name then
		print("No active database set. Use :RyuSetDB to set an active database.")
		return
	end

	local command = "redis-cli GRAPH.QUERY " .. graph_name .. ' "' .. query .. '"'
	if timeout then
		command = command .. " TIMEOUT " .. timeout
	end

	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()

	return result
end

-- Function to run a query using the active database
function M.run_query(optional_query)
	-- Use the provided query if it exists, otherwise prompt the user for a query
	local query = optional_query or vim.fn.input("Enter your query: ")
	if query == "" then
		print("No query entered. Operation cancelled.")
		return
	end

	-- Run the query
	local result = M.query(query)
	require("ryuvim.utils").show_in_float("Query Result:\n" .. result)
end

return M
