local M = {}

-- Define the global variable for the active database
M.active_db = nil

-- Function to set the active database
function M.run()
	local db_list = require("ryuvim.commands.list").run() -- Fetch the list of databases

	-- Open a selection menu to choose the active database
	vim.ui.select(db_list, { prompt = "Select an active database:" }, function(selected_db)
		if selected_db then
			M.active_db = selected_db
			print("Active database set to: " .. M.active_db)
		else
			print("No database selected. Active database not changed.")
		end
	end)
end

return M
