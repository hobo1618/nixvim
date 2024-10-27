vim.api.nvim_create_user_command("SayHello", function()
	print("Hello from print command!")
end, {})
