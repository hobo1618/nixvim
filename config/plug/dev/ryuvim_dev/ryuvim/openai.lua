local M = {}
local curl = require("plenary.curl")

-- Synchronous embedding function
function M.generate_embedding(text)
	local api_key = os.getenv("OPENAI_API_KEY")
	if not api_key then
		print("Error: OPENAI_API_KEY environment variable not set.")
		return nil
	end

	local url = "https://api.openai.com/v1/embeddings"
	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. api_key,
	}

	local body = {
		model = "text-embedding-ada-002",
		input = text,
	}

	local json_body = vim.fn.json_encode(body)

	local response = curl.post(url, {
		headers = headers,
		body = json_body,
	})

	if response and response.status == 200 then
		local response_json = vim.json.decode(response.body) -- Use `vim.json.decode` here
		return response_json.data[1].embedding
	else
		print("Error: " .. (response.status or "Unknown error"))
		return nil
	end
end

-- Asynchronous embedding function
function M.generate_embedding_async(text, callback)
	local api_key = os.getenv("OPENAI_API_KEY")
	if not api_key then
		print("Error: OPENAI_API_KEY environment variable not set.")
		callback(nil)
		return
	end

	local url = "https://api.openai.com/v1/embeddings"
	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. api_key,
	}

	local body = {
		model = "text-embedding-ada-002",
		input = text,
	}

	local json_body = vim.fn.json_encode(body)

	curl.post(url, {
		headers = headers,
		body = json_body,
		callback = function(response)
			if response and response.status == 200 then
				local response_json = vim.json.decode(response.body) -- Use `vim.json.decode` here
				local vector = response_json.data[1].embedding
				vim.schedule(function()
					callback(vector)
				end) -- schedule callback on main thread
			else
				print("Error: " .. (response.status or "Unknown error"))
				vim.schedule(function()
					callback(nil)
				end)
			end
		end,
	})
end

return M
