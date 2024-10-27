vim.api.nvim_create_user_command("RyuHello", function()
	print("Hello from lua module!")
end, {})
