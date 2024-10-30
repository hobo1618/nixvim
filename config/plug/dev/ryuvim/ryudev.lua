local M = {}

function M.setup()
	-- Initialization code here
	print("Plugin loadeds!")
end

function M.hello()
	print("Hello from my pluginsss!")
end

vim.api.nvim_create_user_command("ReloadMyPlugin", function()
	package.loaded["ryudev"] = nil
	require("ryudev").setup()
end, {})

-- Define a command that users can call
vim.api.nvim_create_user_command("RyuHello", M.hello, {})

return M
