local M = {}
local curl = require("plenary.curl")
local db_query = require("ryuvim.commands.query")

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
		model = "text-embedding-3-small",
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

-- Function to execute the query using the embedding and user inputs
local function execute_query(embedding, user_input)
	-- Convert the embedding to a format acceptable by FalkorDB (e.g., vecf32)
	local embedding_str = "[" .. table.concat(embedding, ", ") .. "]"

	-- Construct the Cypher query
	local query = string.format(
		"CALL db.idx.vector.queryNodes('%s', '%s', %d, vecf32(%s)) YIELD node, score",
		user_input.label,
		user_input.attribute,
		user_input.limit,
		embedding_str
	)

	-- For now, we'll just print the query
	print("Generated Cypher Query: " .. query)

	db_query.run_query(query)
end

-- Function to open sequential input fields using vim.ui.input
function M.open_input_fields(embedding)
	local user_input = {}

	-- First input: label
	vim.ui.input({ prompt = "Enter label: " }, function(label)
		if not label then
			print("Input cancelled.")
			return
		end
		user_input.label = label

		-- Second input: attribute
		vim.ui.input({ prompt = "Enter attribute: " }, function(attribute)
			if not attribute then
				print("Input cancelled.")
				return
			end
			user_input.attribute = attribute

			-- Third input: limit
			vim.ui.input({ prompt = "Enter limit (integer): " }, function(limit_str)
				local limit = tonumber(limit_str)
				if not limit then
					print("Error: Limit must be a valid integer.")
					return
				end
				user_input.limit = limit

				-- Execute the query with the embedding and user inputs
				if embedding then
					execute_query(embedding, user_input)
				else
					print("Error: Embedding generation failed.")
				end
			end)
		end)
	end)
end

-- User command to open the query input and form
function M.RyuAsk()
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

	vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
	vim.fn.prompt_setprompt(buf, "Describe your query: ")

	local function on_query_submit()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local user_query = table.concat(lines, "\n")

		vim.api.nvim_win_close(win, true)

		generate_embedding_async(user_query, function(embedding)
			M.open_input_fields(embedding)
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
