vim.api.nvim_create_user_command("SayHello", function()
	print("Hello from nixvim!")
end, {})
