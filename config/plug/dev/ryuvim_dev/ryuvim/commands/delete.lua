local M = {}
-- Mock `db_list` function for demonstration
function M.db_list()
	-- Replace this with the actual call to fetch the database list
	return { "database1", "database2", "database3" }
end

-- Function that runs the shell command with the selected graph
function M.run(graph)
	-- Prompt the user for confirmation
	local choice = vim.fn.confirm("Are you sure you want to delete the graph '" .. graph .. "'?", "&Yes\n&No", 2)

	if choice ~= 1 then
		print("Operation cancelled.")
		return
	end

	-- If confirmed, proceed with the deletion
	local command = "redis-cli GRAPH.DELETE " .. graph
	local output = require("ryuvim.utils").run_shell(command)
	print(output)
end

-- Function to show the list and let the user select a database
function M.delete_graph()
	local databases = M.db_list()

	-- Use `vim.ui.select` to present a menu
	vim.ui.select(databases, { prompt = "Select a database to delete:" }, function(selected)
		if selected then
			M.run(selected)
		else
			print("No database selected. Operation cancelled.")
		end
	end)
end

return M
