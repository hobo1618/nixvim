local M = {}

-- Load modules
local db_list = require("ryuvim.graph.list")
local db_delete = require("ryuvim.graph.delete")
local db_query = require("ryuvim.graph.query")
local set_db = require("ryuvim.graph.set_db")

local db_ask = require("ryuvim.core.ask")

local cypher_create = require("ryuvim.cypher.create")

-- Core Commands
vim.api.nvim_create_user_command("RyuAsk", db_ask.RyuAsk, {})

-- Cypher Commands
vim.api.nvim_create_user_command("CypherCreate", cypher_create.RyuCreate, {})

-- Graph Commands
vim.api.nvim_create_user_command("GraphSelect", set_db.run, {})
vim.api.nvim_create_user_command("GraphQuery", function()
	db_query.run_query()
end, {})
vim.api.nvim_create_user_command("GraphList", db_list.list, {})
-- vim.api.nvim_create_user_command("GraphList", function()
-- 	local dbs = db_list.run()
-- 	if #dbs == 0 then
-- 		print("No databases found.")
-- 		return
-- 	end
--
-- 	-- Print each database name
-- 	--
-- 	local content = { "List of Databases:" }
-- 	print()
-- 	for _, db in ipairs(dbs) do
-- 		-- print("- " .. db)
-- 		table.insert(content, "- " .. db)
-- 	end
-- 	require("ryuvim.utils").show_in_float(table.concat(content, "\n"))
-- end, {})

vim.api.nvim_create_user_command("RyuDelete", function()
	db_delete.delete_graph()
end, {})

function M.setup()
	print("Plugin loaded!")
	-- M.query.setup()
	-- M.delete.setup()
	-- M.list.setup()
	-- list.setup()
	-- Setup calls for other graph
end

return M
