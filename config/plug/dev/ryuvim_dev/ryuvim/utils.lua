local M = {}
local openai = require("ryuvim.openai") -- Import the openai module

function M.run_shell(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	return result
end

-- Utility for displaying output in a floating window with visible actions
function M.show_in_float(content)
	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true)
	local lines = {
		"[Press 's' to save output to a file]",
		"[Press 'q' to close this window]",
		"[Press 'c' to open chat with context]",
		"----------------------------------",
	}
	vim.list_extend(lines, vim.split(content, "\n"))
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

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
		vim.ui.input({ prompt = "Enter filename to save: " }, function(filename)
			if not filename or filename == "" then
				print("No filename provided. Operation cancelled.")
				return
			end

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

	-- Function to handle chat input and send it to the OpenAI API
	local function open_chat()
		vim.ui.input({ prompt = "Enter your message: " }, function(message)
			if not message or message == "" then
				print("No message provided. Operation cancelled.")
				return
			end

			-- Replace 'your_api_key_here' with your actual OpenAI API key
			local api_key = os.getenv("OPENAI_API_KEY")
			local response = openai.send_message(api_key, message, content)

			if response then
				require("ryuvim.utils").show_in_float("Chat Response:\n" .. response)
			else
				print("Failed to get a response from OpenAI.")
			end
		end)
	end

	-- Set keybindings for the floating window
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "", { noremap = true, silent = true, callback = close_window })
	vim.api.nvim_buf_set_keymap(buf, "n", "s", "", { noremap = true, silent = true, callback = save_to_file })
	vim.api.nvim_buf_set_keymap(buf, "n", "c", "", { noremap = true, silent = true, callback = open_chat })
end

return M
