local M = {}

-- Load modules
-- M.query = require("config.plug.dev.ryuvim_dev.ryuvim.commands.query")
-- M.delete = require("config.plug.dev.ryuvim_dev.ryuvim.commands.delete")
-- Load other modules similarly...

vim.api.nvim_create_user_command("RyuHello", M.hello, {})

-- Set up all commands
function M.setup()
	print("Plugin loaded!")
	-- M.query.setup()
	-- M.delete.setup()
	-- Setup calls for other commands
end

return M
