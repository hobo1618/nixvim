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

-- Function to create a new database (placeholder implementation)
local function create_db(db_name)
	-- Placeholder logic to create a new database
	print("Creating database: " .. db_name)
end

-- Function to select a database and then run a query
function M.run_query()
	local db_list = require("ryuvim.commands.list").run() -- Fetch the list of databases

	-- Show a filtered list of databases that match the user's input
	local filtered_list = {}
	for _, db in ipairs(db_list) do
		if db:find(input_db, 1, true) then
			table.insert(filtered_list, db)
		end
	end

	-- If there are matching databases, let the user select one
	if #filtered_list > 0 then
		vim.ui.select(filtered_list, { prompt = "Select a matching database:" }, function(selected_db)
			if selected_db then
				input_db = selected_db
			end

			-- Check if the database exists after the selection
			if not db_exists(input_db, db_list) then
				local choice = vim.fn.confirm(
					"The database '" .. input_db .. "' does not exist. Do you want to create it?",
					"&Yes\n&No",
					2
				)

				if choice == 1 then
					create_db(input_db)
				else
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
			require("ryuvim.utils").show_in_float(result)
		end)
	else
		-- If no matching databases, proceed with the input as-is
		if not db_exists(input_db, db_list) then
			local choice = vim.fn.confirm(
				"The database '" .. input_db .. "' does not exist. Do you want to create it?",
				"&Yes\n&No",
				2
			)

			if choice == 1 then
				create_db(input_db)
			else
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
		require("ryuvim.utils").show_in_float(result)
	end
end

return M
