-- graph_query.lua
local M = {}

-- Function to execute GRAPH.QUERY
function M.query(graph_name, query, timeout)
	-- Construct the command
	local command = "redis-cli GRAPH.QUERY " .. graph_name .. ' "' .. query .. '"'
	if timeout then
		command = command .. " TIMEOUT " .. timeout
	end

	-- Execute the command and capture the output
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()

	-- Process the result as needed
	-- For example, you might want to parse the result into a Lua table

	return result
end

return M
