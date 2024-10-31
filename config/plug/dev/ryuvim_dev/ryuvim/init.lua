local M = {}

-- Load modules
local list = require("ryuvim.commands.list")
-- M.list = require("ryuvim.commands.list")
-- M.query = require("config.plug.dev.ryuvim_dev.ryuvim.commands.query")
-- M.delete = require("config.plug.dev.ryuvim_dev.ryuvim.commands.delete")
-- Load other modules similarly...

function M.hello()
	print("Hello from my plugin!")
	print(list.setup())
end

vim.api.nvim_create_user_command("RyuHello", M.hello, {})
vim.api.nvim_create_user_command("FalkorList", list.run(), {})

function M.setup()
	print("Plugin loaded!")
	-- M.query.setup()
	-- M.delete.setup()
	-- M.list.setup()
	-- list.setup()
	-- Setup calls for other commands
end

return M
