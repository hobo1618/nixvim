local M = {}
local curl = require("plenary.curl")

-- Function to generate the embedding asynchronously
-- Function to generate the embedding asynchronously
local function generate_embedding_async(description, callback)
	-- Retrieve the API key from the environment variable
	local api_key = os.getenv("OPENAI_API_KEY")
	if not api_key then
		print("Error: OPENAI_API_KEY environment variable not set.")
		return
	end

	-- Prepare the API endpoint and headers
	local url = "https://api.openai.com/v1/embeddings"
	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. api_key,
	}

	-- Prepare the body of the request
	local body = {
		model = "text-embedding-ada-002", -- Example embedding model
		input = description,
	}

	-- Convert the body to a JSON string
	local json_body = vim.fn.json_encode(body)

	-- Send the request using Plenary's curl asynchronously
	curl.post(url, {
		headers = headers,
		body = json_body,
		callback = function(response)
			if response and response.status == 200 then
				-- Use vim.json.decode instead of vim.fn.json_decode
				local response_json = vim.json.decode(response.body)
				local embedding = response_json.data[1].embedding
				callback(embedding)
			else
				print("Error: " .. (response.status or "Unknown error"))
				callback(nil)
			end
		end,
	})
end

-- Function to open the form for label, attribute, and limit input
function M.open_form_for_query(embedding)
	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.5)
	local height = 7
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "single",
	})

	-- Set buffer content with input field labels
	local lines = {
		"Enter details for your query:",
		"label: ",
		"attribute: ",
		"limit to: ",
		"[Press Enter to submit]",
	}
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- Table to store user input
	local user_input = { label = "", attribute = "", limit = "" }
	local current_line = 2 -- Starting at the line where the first input is

	-- Function to handle user input submission
	local function on_submit()
		-- Get the values entered by the user
		user_input.label = vim.api.nvim_buf_get_lines(buf, 1, 2, false)[1]:gsub("label: ", "")
		user_input.attribute = vim.api.nvim_buf_get_lines(buf, 2, 3, false)[1]:gsub("attribute: ", "")
		user_input.limit = tonumber(vim.api.nvim_buf_get_lines(buf, 3, 4, false)[1]:gsub("limit to: ", ""))

		-- Close the floating window
		vim.api.nvim_win_close(win, true)

		-- Print the results (later, you'll execute the query)
		if embedding then
			print("Embedding: ", table.concat(embedding, ", "))
			print("Label: ", user_input.label)
			print("Attribute: ", user_input.attribute)
			print("Limit: ", user_input.limit)
		else
			print("Error: Embedding generation failed.")
		end
	end

	-- Set keybinding for <Enter> to submit the form
	vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", "", {
		noremap = true,
		silent = true,
		callback = on_submit,
	})
end

-- User command to open the query input and form
function M.RyuAsk()
	-- Open the input buffer for the natural language query
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.3)
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

	-- Function to handle the user's query description
	local function on_query_submit()
		-- Get the content from the buffer
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local user_query = table.concat(lines, "\n")

		-- Close the floating window
		vim.api.nvim_win_close(win, true)

		-- Generate the embedding asynchronously
		generate_embedding_async(user_query, function(embedding)
			-- Open the form once the embedding is ready
			M.open_form_for_query(embedding)
		end)
	end

	-- Set keybinding for <Enter> to submit the query
	vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", "", {
		noremap = true,
		silent = true,
		callback = on_query_submit,
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

return M
