local M = {}

-- Load modules
local db_list = require("ryuvim.commands.list")
local db_delete = require("ryuvim.commands.delete")
local db_query = require("ryuvim.commands.query")
-- M.list = require("ryuvim.commands.list")
-- M.query = require("config.plug.dev.ryuvim_dev.ryuvim.commands.query")
-- M.delete = require("config.plug.dev.ryuvim_dev.ryuvim.commands.delete")
-- Load other modules similarly...

function M.hello()
	print("Hello from my plugin!")
end

vim.api.nvim_create_user_command("RyuDBQuery", db_query.run_query, {})
vim.api.nvim_create_user_command("RyuDBList", function()
	local dbs = db_list.run()
	if #dbs == 0 then
		print("No databases found.")
		return
	end

	-- Print each database name
	--
	local content = { "List of Databases:" }
	print()
	for _, db in ipairs(dbs) do
		-- print("- " .. db)
		table.insert(content, "- " .. db)
	end
	require("ryuvim.utils").show_in_float(table.concat(content, "\n"))
end, {})
vim.api.nvim_create_user_command("RyuDBDelete", function()
	db_delete.delete_graph()
end, {})

function M.setup()
	print("Plugin loaded!")
	-- M.query.setup()
	-- M.delete.setup()
	-- M.list.setup()
	-- list.setup()
	-- Setup calls for other commands
end

return M
