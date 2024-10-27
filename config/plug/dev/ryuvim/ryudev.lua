vim.api.nvim_create_user_command("RyuDev", function()
	print("Hello from dev module in dev directory!")
end, {})
