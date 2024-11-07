local M = {}

-- Function to create a new graph or interact with an existing one
function M.create_graph()
	-- Prompt the user for a graph name
	vim.ui.input({ prompt = "Enter graph name: " }, function(graph_name)
		if not graph_name or graph_name == "" then
			print("Graph creation cancelled.")
			return
		end

		-- Define the command to check or create the graph
		local command = "redis-cli GRAPH.QUERY " .. graph_name .. ' "MATCH (n) RETURN n"'

		-- Run the command and capture output
		local handle = io.popen(command)
		local result = handle:read("*a")
		handle:close()

		-- Output the result to confirm success or show an error
		if result and result:match("Query internal execution time") then
			print("Graph '" .. graph_name .. "' checked/created successfully!")
		else
			print("Failed to create or access graph: " .. result)
		end
	end)
end

return M
