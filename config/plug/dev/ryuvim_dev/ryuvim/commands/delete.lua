local M = {}

function M.run(graph)
	-- Prompt the user for confirmation
	local choice = vim.fn.confirm("Are you sure you want to delete the graph '" .. graph .. "'?", "&Yes\n&No", 2)

	if choice ~= 1 then
		print("Operation cancelled.")
		return
	end
	-- Construct the shell command with the provided graph argument
	local command = "redis-cli GRAPH.DELETE " .. graph
	local output = require("ryuvim.utils").run_shell(command)

	-- Print the output for now
	print(output)
end

return M
