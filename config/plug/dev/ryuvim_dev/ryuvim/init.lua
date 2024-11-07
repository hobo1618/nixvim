local M = {}

-- Load modules
local db_list = require("ryuvim.graph.list")
local db_delete = require("ryuvim.graph.delete")
local db_query = require("ryuvim.graph.query")
local set_db = require("ryuvim.graph.set_db")
local db_ask = require("ryuvim.core.ask")
local cypher_create = require("ryuvim.cypher.create")
local db_copy = require("ryuvim.graph.copy")
local graph_save = require("ryuvim.graph.save")

-- Core Commands
vim.api.nvim_create_user_command("RyuAsk", db_ask.RyuAsk, {})

-- Cypher Commands
vim.api.nvim_create_user_command("CypherCreate", cypher_create.RyuCreate, {})

-- Graph Commands
vim.api.nvim_create_user_command("GraphSave", graph_save.save_graph, {})
vim.api.nvim_create_user_command("GraphSelect", set_db.run, {})
vim.api.nvim_create_user_command("GraphQuery", function()
	db_query.run_query()
end, {})
vim.api.nvim_create_user_command("GraphList", db_list.display_graphs, {})
vim.api.nvim_create_user_command("GraphCopy", function()
	db_copy.run_copy()
end, {})
vim.api.nvim_create_user_command("GraphDelete", function()
	db_delete.delete_graph()
end, {})

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		graph_save.save_graph()
	end,
})

function M.setup()
	print("Plugin loaded!")
	-- M.query.setup()
	-- M.delete.setup()
	-- M.list.setup()
	-- list.setup()
	-- Setup calls for other graph
end

return M
