local M = {}
local list_module = require("ryuvim.graph.list") -- Assuming `list` provides the list of graphs

-- Function to copy a graph
function M.copy_graph(src, dest)
	if not src or not dest then
		print("Error: Source and destination graph names are required.")
		return
	end

	local command = "redis-cli GRAPH.COPY " .. src .. " " .. dest

	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()

	if result then
		print("Graph copied successfully from " .. src .. " to " .. dest .. ".")
	else
		print("Error: Failed to copy the graph.")
	end
end

-- Command to handle the graph copy process
function M.run_copy()
	local db_list = list_module.run() -- Fetch the list of available graphs

	-- Show a selection menu to choose the source graph
	vim.ui.select(db_list, { prompt = "Select source graph:" }, function(src)
		if not src then
			print("No source graph selected. Operation cancelled.")
			return
		end

		-- Prompt for the destination graph name
		vim.ui.input({ prompt = "Enter destination graph name: " }, function(dest)
			if not dest or dest == "" then
				print("No destination name entered. Operation cancelled.")
				return
			end

			-- Copy the graph
			M.copy_graph(src, dest)
		end)
	end)
end

return M
