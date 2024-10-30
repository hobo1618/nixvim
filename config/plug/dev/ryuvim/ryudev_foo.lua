local M = {}

function M.setup()
	-- Initialization code here
	print("Plugin loadeds!")
end

function M.hello()
	print("Hello from my plugin!")
end

vim.api.nvim_create_user_command("RyuGraphList", function()
	local handle = io.popen("redis-cli GRAPH.LIST") -- Run the shell command
	if handle then
		local result = handle:read("*a") -- Read the output
		handle:close() -- Close the handle
		print(result) -- Print the result in Neovim
	else
		print("Failed to run redis-cli GRAPH.LIST")
	end
end, {})

vim.api.nvim_create_user_command("RedisGraphList", function()
	local handle = io.popen("redis-cli GRAPH.LIST")
	if handle then
		local result = handle:read("*a")
		handle:close()

		-- Create a floating window to display the result
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))
		vim.api.nvim_open_win(buf, true, {
			relative = "editor",
			width = math.floor(vim.o.columns * 0.8),
			height = math.floor(vim.o.lines * 0.8),
			row = math.floor(vim.o.lines * 0.1),
			col = math.floor(vim.o.columns * 0.1),
			style = "minimal",
			border = "single",
		})
	else
		print("Failed to run redis-cli GRAPH.LIST")
	end
end, {})

-- Define a command that users can call
vim.api.nvim_create_user_command("RyuHello", M.hello, {})

return M
