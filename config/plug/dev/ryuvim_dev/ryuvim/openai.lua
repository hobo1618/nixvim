local M = {}

local http = require("socket.http")
local ltn12 = require("ltn12")

-- Function to send a request to the OpenAI API
function M.send_message(api_key, message, context)
	-- Prepare the API endpoint and headers
	local url = "https://api.openai.com/v1/chat/completions"
	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. api_key,
	}

	-- Prepare the body of the request
	local body = {
		model = "gpt-4o-mini", -- You can adjust the model as needed
		messages = {
			{ role = "system", content = context },
			{ role = "user", content = message },
		},
	}

	-- Convert the body to a JSON string
	local json_body = vim.fn.json_encode(body)

	-- Set up the response capture
	local response_body = {}
	local result, response_code, response_headers, response_status = http.request({
		url = url,
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = tostring(#json_body),
			["Authorization"] = "Bearer " .. api_key,
		},
		source = ltn12.source.string(json_body),
		sink = ltn12.sink.table(response_body),
	})

	-- Check the response
	if result and response_code == 200 then
		-- Parse the response JSON and return the content
		local response_json = vim.fn.json_decode(table.concat(response_body))
		return response_json.choices[1].message.content
	else
		print("Error: " .. (response_status or "Unknown error"))
		return nil
	end
end

return M
