local M = {}

function M.run()
	local output = require("ryuvim.utils").run_shell("redis-cli GRAPH.LIST")
	print(output) -- For now, print to the command area. Replace with a buffer for larger output.
end

function M.setup()
	print("List command loaded!")
	vim.api.nvim_create_user_command("FalkorList", M.run, {})
end

return M
