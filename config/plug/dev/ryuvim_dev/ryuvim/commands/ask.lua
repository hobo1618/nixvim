local M = {}
local curl = require("plenary.curl")

-- Function to generate the embedding asynchronously
local function generate_embedding_async(description, callback)
	local api_key = os.getenv("OPENAI_API_KEY")
	if not api_key then
		print("Error: OPENAI_API_KEY environment variable not set.")
		return
	end

	local url = "https://api.openai.com/v1/embeddings"
	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. api_key,
	}

	local body = {
		model = "text-embedding-ada-002",
		input = description,
	}

	local json_body = vim.fn.json_encode(body)

	curl.post(url, {
		headers = headers,
		body = json_body,
		callback = function(response)
			if response and response.status == 200 then
				local response_json = vim.json.decode(response.body)
				local embedding = response_json.data[1].embedding
				vim.schedule(function()
					callback(embedding)
				end)
			else
				vim.schedule(function()
					print("Error: " .. (response.status or "Unknown error"))
					callback(nil)
				end)
			end
		end,
	})
end

-- Function to open the form for label, attribute, and limit input
function M.open_form_for_query(embedding)
	vim.schedule(function()
		local buf = vim.api.nvim_create_buf(true, true) -- Make it a listed buffer
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

		local lines = {
			"Enter details for your query:",
			"label: ",
			"attribute: ",
			"limit to: ",
			"[Press Enter to submit]",
		}
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

		local user_input = { label = "", attribute = "", limit = "" }

		local function on_submit()
			user_input.label = vim.api.nvim_buf_get_lines(buf, 1, 2, false)[1]:gsub("label: ", "")
			user_input.attribute = vim.api.nvim_buf_get_lines(buf, 2, 3, false)[1]:gsub("attribute: ", "")

			local limit_str = vim.api.nvim_buf_get_lines(buf, 3, 4, false)[1]:gsub("limit to: ", "")
			user_input.limit = tonumber(limit_str)

			if not user_input.limit then
				print("Error: 'limit to' must be a valid integer.")
				return
			end

			vim.api.nvim_win_close(win, true)

			if embedding then
				print("Embedding: ", table.concat(embedding, ", "))
				print("Label: ", user_input.label)
				print("Attribute: ", user_input.attribute)
				print("Limit: ", user_input.limit)
			else
				print("Error: Embedding generation failed.")
			end
		end

		vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", "", {
			noremap = true,
			silent = true,
			callback = on_submit,
		})
	end)
end

function M.RyuAsk()
	local buf = vim.api.nvim_create_buf(true, true) -- Make it a listed buffer
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

	vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
	vim.fn.prompt_setprompt(buf, "Describe your query: ")

	local function on_query_submit()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local user_query = table.concat(lines, "\n")

		vim.api.nvim_win_close(win, true)

		generate_embedding_async(user_query, function(embedding)
			M.open_form_for_query(embedding)
		end)
	end

	vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", "", {
		noremap = true,
		silent = true,
		callback = on_query_submit,
	})

	vim.api.nvim_buf_set_keymap(buf, "i", "<Esc>", "", {
		noremap = true,
		silent = true,
		callback = function()
			vim.api.nvim_win_close(win, true)
		end,
	})
end

vim.api.nvim_create_user_command("RyuAsk", M.RyuAsk, {})

return M
