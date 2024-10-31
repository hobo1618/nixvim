local M = {}

-- Load modules
local db_list = require("ryuvim.commands.list")
local db_delete = require("ryuvim.commands.delete")
-- M.list = require("ryuvim.commands.list")
-- M.query = require("config.plug.dev.ryuvim_dev.ryuvim.commands.query")
-- M.delete = require("config.plug.dev.ryuvim_dev.ryuvim.commands.delete")
-- Load other modules similarly...

function M.hello()
	print("Hello from my plugin!")
end

vim.api.nvim_create_user_command("RyuHello", M.hello, {})
vim.api.nvim_create_user_command("RyuDBList", db_list.run, {})
vim.api.nvim_create_user_command("RyuDBDelete", function()
	db_delete.delete_graph()
end, {})

function M.setup()
	print("Plugin loaded!")
	-- M.query.setup()
	-- M.delete.setup()
	-- M.list.setup()
	-- list.setup()
	-- Setup calls for other commands
end

return M
