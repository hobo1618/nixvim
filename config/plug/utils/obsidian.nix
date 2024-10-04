{ lib, helpers, ... }:
{
  plugins.obsidian = {
    enable = true;
    settings = {
      completion = {
        min_chars = 2;
        nvim_cmp = true;
      };
      new_notes_location = "notes_subdir";
      workspaces = [
        {
          name = "sat";
          path = "~/Documents/askerra/vault/sat";
        }
      ];
      note_id_func = ''
        function(title)
          -- see https://nix-community.github.io/nixvim/plugins/obsidian/settings/index.html

          local suffix = ""
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            title = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            return title
          else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      '';
      mappings = {
        gf = {
          action = "require('obsidian').util.gf_passthrough";
          opts = {
            noremap = false;
            expr = true;
            buffer = true;
          };
        };
        "<leader>ch" = {
          action = "require('obsidian').util.toggle_checkbox";
          opts.buffer = true;
        };
      };
    };
  };
}
