local M = {}

function M.run_shell(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	return result
end

-- Utility for displaying output in a floating window with visible actions
function M.show_in_float(content)
	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true) -- (false, true) makes it non-listed and scratch

	-- Prepare the lines to display, including the action shortcuts
	local lines = {
		"[Press 's' to save output to a file]",
		"[Press 'q' to close this window]",
		"----------------------------------", -- Separator line
	}
	vim.list_extend(lines, vim.split(content, "\n"))

	-- Set the lines in the buffer
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- Create the floating window
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor(vim.o.lines * 0.1),
		col = math.floor(vim.o.columns * 0.1),
		style = "minimal",
		border = "single",
	})

	-- Function to close the floating window
	local function close_window()
		vim.api.nvim_win_close(win, true)
	end

	-- Function to save the content to a file
	local function save_to_file()
		-- Prompt the user for a filename
		vim.ui.input({ prompt = "Enter filename to save: " }, function(filename)
			if not filename or filename == "" then
				print("No filename provided. Operation cancelled.")
				return
			end

			-- Save the content to the specified file
			local file = io.open(filename, "w")
			if file then
				file:write(content)
				file:close()
				print("Output saved to " .. filename)
			else
				print("Error: Unable to save the file.")
			end
		end)
	end

	-- Set keybindings for the floating window
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "", { noremap = true, silent = true, callback = close_window })
	vim.api.nvim_buf_set_keymap(buf, "n", "s", "", { noremap = true, silent = true, callback = save_to_file })
end

return M
