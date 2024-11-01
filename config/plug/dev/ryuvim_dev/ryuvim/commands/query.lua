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

-- Function to check if a database exists in the list
local function db_exists(db_name, db_list)
	for _, db in ipairs(db_list) do
		if db == db_name then
			return true
		end
	end
	return false
end

-- Function to select a database and then run a query
function M.run_query()
	local db_list = require("ryuvim.commands.list").run() -- Fetch the list of databases

	-- Show a selection menu for the databases
	vim.ui.select(db_list, { prompt = "Select a database:" }, function(selected_db)
		if selected_db == "" then
			print("No database selected. Operation cancelled.")
			return
		end

		-- Check if the database exists after the selection
		if not db_exists(selected_db, db_list) then
			local choice = vim.fn.confirm(
				"The database '" .. selected_db .. "' does not exist. Do you want to create it?",
				"&Yes\n&No",
				2
			)

			if choice == 0 then
				print("Operation aborted.")
				return
			end
		end

		-- Prompt the user to enter the query
		local query = vim.fn.input("Enter your query: ")

		if query == "" then
			print("No query entered. Operation cancelled.")
			return
		end

		-- Run the query
		local result = M.query(selected_db, query)
		require("ryuvim.utils").show_in_float("Query Result:\n" .. result)
	end)
end

return M
