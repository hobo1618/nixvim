local M = {}

-- Function to open a floating buffer for user input
function M.open_query_input()
	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true) -- (false, true) makes it a scratch buffer
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.3)

	-- Create a floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "single",
	})

	-- Set buffer options
	vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
	vim.fn.prompt_setprompt(buf, "Describe your query: ")

	-- Function to handle the user's input
	local function on_submit()
		-- Get the content from the buffer
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local user_input = table.concat(lines, "\n")

		-- Close the floating window
		vim.api.nvim_win_close(win, true)

		-- Here, you would later call your embedding generation and query logic
		print("User query description: " .. user_input)
	end

	-- Set keybinding for <Enter> to submit the input
	vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", "", {
		noremap = true,
		silent = true,
		callback = on_submit,
	})

	-- Set keybinding for <Esc> to close the floating window without submitting
	vim.api.nvim_buf_set_keymap(buf, "i", "<Esc>", "", {
		noremap = true,
		silent = true,
		callback = function()
			vim.api.nvim_win_close(win, true)
		end,
	})
end

-- Create the RyuAsk user command
vim.api.nvim_create_user_command("RyuAsk", M.open_query_input, {})

return M
