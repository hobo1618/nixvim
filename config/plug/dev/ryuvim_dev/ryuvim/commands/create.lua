local M = {}
local set_db = require("ryuvim.commands.set_db")
local query_module = require("ryuvim.commands.query")
local generate_embedding_async = require("ryuvim.openai").generate_embedding

-- Utility function to extract YAML frontmatter and markdown body
local function parse_markdown_buffer(buffer_content)
	local frontmatter = {}
	local body = {}
	local in_frontmatter = false
	for _, line in ipairs(buffer_content) do
		if line:match("^---$") then
			in_frontmatter = not in_frontmatter
		elseif in_frontmatter then
			local key, value = line:match("^(%w+):%s*(.*)$")
			if key and value then
				frontmatter[key] = value
			end
		else
			table.insert(body, line)
		end
	end
	return frontmatter, table.concat(body, "\n")
end

-- Function to create the node
local function create_node_from_buffer(buffer_content)
	local frontmatter, body_content = parse_markdown_buffer(buffer_content)

	-- Check if label is defined in frontmatter
	local label = frontmatter.label
	if not label then
		print("Error: 'label' field is required in the frontmatter.")
		return
	end

	-- Generate the embedding for the body content
	generate_embedding_async(body_content, function(embedding)
		if not embedding then
			print("Error: Failed to generate embedding.")
			return
		end

		-- Format properties into Cypher syntax
		frontmatter.content = body_content
		frontmatter.embedding = "vecf32([" .. table.concat(embedding, ", ") .. "])" -- Embed vector in Cypher format

		-- Construct the Cypher properties string
		local properties = {}
		for key, value in pairs(frontmatter) do
			table.insert(properties, key .. ": '" .. value:gsub("'", "\\'") .. "'")
		end

		local query = string.format("CREATE (:%s {%s})", label, table.concat(properties, ", "))
		query_module.run_query(query)
	end)
end

-- Command to create a node from the current buffer
function M.RyuCreate()
	if not set_db.active_db then
		print("No active database set. Use :RyuSetDB to set an active database.")
		return
	end

	local buffer_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	create_node_from_buffer(buffer_content)
end

return M
