-- graph_query.lua
local M = {}

-- Function to check if a database exists in the list
local function db_exists(db_name, db_list)
	for _, db in ipairs(db_list) do
		if db == db_name then
			return true
		end
	end
	return false
end

-- Function to create a new database (placeholder implementation)
local function create_db(db_name)
	-- Placeholder logic to create a new database
	print("Creating database: " .. db_name)
end

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

	-- Prompt the user to enter or select a database
	vim.ui.input({ prompt = "Enter or select a database:" }, function(input_db)
		if not input_db or input_db == "" then
			print("No database selected. Operation cancelled.")
			return
		end

		-- Check if the database exists
		if not db_exists(input_db, db_list) then
			-- If the database does not exist, prompt the user
			local choice = vim.fn.confirm(
				"The database '" .. input_db .. "' does not exist. Do you want to create it?",
				"&Yes\n&No",
				2
			)

			if choice == 1 then
				-- User chose to create the database
				create_db(input_db)
			else
				-- User chose to abort
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
		local result = M.query(input_db, query)

		-- Display the result in a floating buffer
		require("ryuvim.utils").show_in_float(result)
	end)
end

return M
