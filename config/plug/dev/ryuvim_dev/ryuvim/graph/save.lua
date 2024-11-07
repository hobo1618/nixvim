local M = {}

-- Function to save the current state of the database
function M.save_graph()
	local handle = io.popen("redis-cli -p 6379 SAVE")
	local result = handle:read("*a")
	handle:close()

	if result:match("OK") then
		print("Database saved successfully!")
	else
		print("Failed to save the database.")
	end
end

return M
