local M = {}
local curl = require("plenary.curl")

-- Function to send a message to the OpenAI API and get a vector representation
function M.generate_embedding(text)
	-- Retrieve the API key from the environment variable
	local api_key = os.getenv("OPENAI_API_KEY")
	if not api_key then
		print("Error: OPENAI_API_KEY environment variable not set.")
		return nil
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
		input = text,
	}

	-- Convert the body to a JSON string
	local json_body = vim.fn.json_encode(body)

	-- Send the request using Plenary's curl
	local response = curl.post(url, {
		headers = headers,
		body = json_body,
	})

	-- Check the response
	if response and response.status == 200 then
		-- Parse the response JSON and extract the vector
		local response_json = vim.fn.json_decode(response.body)
		local vector = response_json.data[1].embedding
		return vector
	else
		print("Error: " .. (response.status or "Unknown error"))
		return nil
	end
end

-- Function to send a request to the OpenAI API using Plenary's curl
function M.send_message(api_key, message, context)
	-- Prepare the API endpoint and headers
	local url = "https://api.openai.com/v1/chat/completions"
	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. api_key,
	}

	-- Prepare the body of the request
	local body = {
		model = "gpt-3.5-turbo", -- You can adjust the model as needed
		messages = {
			{ role = "system", content = context },
			{ role = "user", content = message },
		},
	}

	-- Convert the body to a JSON string
	local json_body = vim.fn.json_encode(body)

	-- Send the request using Plenary's curl
	local response = curl.post(url, {
		headers = headers,
		body = json_body,
	})

	-- Check the response
	if response and response.status == 200 then
		-- Parse the response JSON and return the content
		local response_json = vim.fn.json_decode(response.body)
		print(vim.inspect(response_json))
		return response_json.choices[1].message.content
	else
		print("Error: " .. (response.status or "Unknown error"))
		return nil
	end
end

return M
