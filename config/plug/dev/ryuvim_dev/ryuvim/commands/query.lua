local M = {}

-- Function to execute GRAPH.QUERY
function M.query(graph_name, query, timeout)
	-- Ensure the query is a string, even if it's passed as nil
	-- if type(query) ~= "string" then
	-- 	query = "MATCH (n) RETURN n LIMIT 10" -- Fallback to a default query
	-- end

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
function M.run_query(optional_query)
	local db_list = require("ryuvim.commands.list").run() -- Fetch the list of databases

	-- Append "Create New" to the list of databases
	table.insert(db_list, "Create New")

	-- Show a selection menu for the databases
	vim.ui.select(db_list, { prompt = "Select a database:" }, function(selected_db)
		if not selected_db then
			print("No database selected. Operation cancelled.")
			return
		end

		-- If the user selects "Create New", prompt for a new database name
		if selected_db == "Create New" then
			vim.ui.input({ prompt = "Enter a name for the new database:" }, function(new_db_name)
				if not new_db_name or new_db_name == "" then
					print("No database name entered. Operation cancelled.")
					return
				end

				-- Check if the new database name already exists
				if db_exists(new_db_name, db_list) then
					print("The database name '" .. new_db_name .. "' already exists. Operation cancelled.")
					return
				end

				-- Use the new database name for the query
				selected_db = new_db_name

				-- Use the provided query if it exists, otherwise prompt the user for a query
				local query = optional_query or vim.fn.input("Enter your query: ")
				if query == "" then
					print("No query entered. Operation cancelled.")
					return
				end

				-- Run the query
				local result = M.query(selected_db, query)
				require("ryuvim.utils").show_in_float("Query Result:\n" .. result)
			end)
		else
			-- If the user selects an existing database, use the provided query or prompt for one
			local query = optional_query or vim.fn.input("Enter your query: ")
			-- local query = vim.fn.input("Enter your query: ")
			if query == "" then
				print("No query entered. Operation cancelled.")
				return
			end

			-- Run the query
			local result = M.query(selected_db, query)
			require("ryuvim.utils").show_in_float("Query Result:\n" .. result)
		end
	end)
end

return M
