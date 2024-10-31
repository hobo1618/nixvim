local M = {}

function M.run(graph)
	-- Construct the shell command with the provided graph argument
	local command = "redis-cli GRAPH.DELETE " .. graph
	local output = require("ryuvim.utils").run_shell(command)

	-- Print the output for now
	print(output)
end

return M
