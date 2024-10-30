local M = {}

-- Load modules
-- M.list = require("ryuvim.commands.list")
M.foo = require("ryuvim.foo")
-- M.query = require("config.plug.dev.ryuvim_dev.ryuvim.commands.query")
-- M.delete = require("config.plug.dev.ryuvim_dev.ryuvim.commands.delete")
-- Load other modules similarly...

function M.hello()
	print("Hello from my plugin!")
end

vim.api.nvim_create_user_command("RyuHello", M.hello, {})

-- Set up all commands
function M.setup()
	print("Plugin loaded!")
	-- M.query.setup()
	-- M.delete.setup()
	-- M.list.setup()
	M.foo.setup()
	-- Setup calls for other commands
end

return M
