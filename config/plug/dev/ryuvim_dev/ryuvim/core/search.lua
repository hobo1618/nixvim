local M = {}

function M.fetch_results(label)
	-- Construct the Cypher query
	local query = "MATCH (n:" .. label .. ") RETURN n"

	-- Use GraphQuery to execute the query
	local db_query = require("ryuvim.graph.query")
	local raw_result = db_query.query(query) -- Assume run_query returns raw result string
	print(raw_result .. " <== raw_result") -- Debugging output

	-- Check if the raw result is nil or empty
	if not raw_result or raw_result == "" then
		print("No results found for label: " .. label)
		return nil
	end

	-- Split the raw result by lines, filtering out metadata and empty lines
	local result_lines = {}
	for line in raw_result:gmatch("[^\r\n]+") do
		if
			not line:match("Cached execution")
			and not line:match("Query internal execution time")
			and line:match("%S")
		then
			table.insert(result_lines, line)
		end
	end

	-- Verify if we have at least header + data lines
	if #result_lines < 2 then
		print("Not enough results found for label: " .. label)
		return nil
	end

	-- Parse the data lines to extract `title` and `content`
	local results = {}
	for i = 2, #result_lines do -- Start from 2 to skip the header line
		local line = result_lines[i]
		-- Assuming the format is CSV-like with `n.test` and `n.content`
		local title, content = line:match("([^,]+)%s*,%s*(.*)")
		if title and content then
			table.insert(results, { title = title:match("^%s*(.-)%s*$"), content = content:match("^%s*(.-)%s*$") }) -- Trim whitespace
		end
	end

	-- Return parsed results
	return results
end

-- Function to display search results with filtering and preview
function M.ryu_search(label)
	-- Fetch results based on label
	local results = M.fetch_results(label)

	if not results or #results == 0 then
		print("No results found for label: " .. label)
		return
	end

	-- Create the floating buffer for the list
	local list_buf = vim.api.nvim_create_buf(false, true)
	local list_win = vim.api.nvim_open_win(list_buf, true, {
		relative = "editor",
		width = math.floor(vim.o.columns * 0.3),
		height = math.floor(vim.o.lines * 0.8),
		row = 1,
		col = 1,
		style = "minimal",
		border = "single",
	})

	-- Create the floating buffer for the preview panel
	local preview_buf = vim.api.nvim_create_buf(false, true)
	local preview_win = vim.api.nvim_open_win(preview_buf, true, {
		relative = "editor",
		width = math.floor(vim.o.columns * 0.5),
		height = math.floor(vim.o.lines * 0.8),
		row = 1,
		col = math.floor(vim.o.columns * 0.35),
		style = "minimal",
		border = "single",
	})

	-- Set up the input prompt at the top of the list buffer
	vim.api.nvim_buf_set_option(list_buf, "buftype", "prompt")
	vim.fn.prompt_setprompt(list_buf, "Filter: ")

	-- Populate the list buffer with results
	local function populate_list(filtered_results)
		vim.api.nvim_buf_set_lines(list_buf, 1, -1, false, filtered_results)
	end

	-- Show full content preview of the selected result
	local function update_preview(index)
		local content = results[index] and results[index].content or ""
		vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, vim.split(content, "\n"))
		vim.api.nvim_buf_set_option(preview_buf, "filetype", "markdown") -- Render as markdown
	end

	-- Initial populate of the list and preview
	populate_list(vim.tbl_map(function(item)
		return item.title
	end, results))
	update_preview(1)

	-- Add filtering functionality
	local function filter_results(query)
		local filtered = {}
		for _, item in ipairs(results) do
			if item.title:lower():find(query:lower()) then
				table.insert(filtered, item.title)
			end
		end
		populate_list(filtered)
	end

	-- Handle navigation and input
	local current_selection = 1
	vim.api.nvim_buf_set_keymap(list_buf, "i", "<C-j>", "", {
		noremap = true,
		silent = true,
		callback = function()
			current_selection = math.min(current_selection + 1, #results)
			update_preview(current_selection)
			vim.api.nvim_win_set_cursor(list_win, { current_selection + 1, 0 })
		end,
	})
	vim.api.nvim_buf_set_keymap(list_buf, "i", "<C-k>", "", {
		noremap = true,
		silent = true,
		callback = function()
			current_selection = math.max(current_selection - 1, 1)
			update_preview(current_selection)
			vim.api.nvim_win_set_cursor(list_win, { current_selection + 1, 0 })
		end,
	})

	-- Update preview when filter is typed
	vim.api.nvim_buf_attach(list_buf, false, {
		on_lines = function()
			local query = vim.api.nvim_buf_get_lines(list_buf, 0, 1, false)[1]:gsub("Filter: ", "")
			filter_results(query)
		end,
	})

	-- Close windows with <Esc>
	vim.api.nvim_buf_set_keymap(list_buf, "i", "<Esc>", "", {
		noremap = true,
		silent = true,
		callback = function()
			vim.api.nvim_win_close(list_win, true)
			vim.api.nvim_win_close(preview_win, true)
		end,
	})
end

return M
