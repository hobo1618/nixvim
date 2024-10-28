{ lib, config, ... }:
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
          name = "notes";
          path = "~/Documents/obsidian";
        }
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
            math.randomseed(os.time())

            -- If title is nil, create a unique id.
            local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            local id_length = 8
            local id = {}
        
            for i = 1, id_length do
                local rand = math.random(1, #charset)
                table.insert(id, charset:sub(rand, rand))
            end

            return table.concat(id)

          end
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
  keymaps = lib.mkIf config.plugins.obsidian.enable [
    {
      mode = "n";
      key = "<leader>on";
      action = "<cmd>ObsidianNew<cr>";
      options = {
        desc = "New Obsidian Note";
      };
    }
    {
      mode = "n";
      key = "<leader>oo";
      action = "<cmd>ObsidianOpen<cr>";
      options = {
        desc = "Open a note in the Obsidian app. This command has one optional argument: a query used to resolve the note to open by ID, path, or alias. If not given, the note corresponding to the current buffer is opened";
      };
    }
    {
      mode = "n";
      key = "<leader>oqs";
      action = "<cmd>ObsidianQuickSwitch<cr>";
      options = {
        desc = "Quickly switch to (or open) another note in your vault, searching by its name using ripgrep with your preferred picker (see plugin dependencies below).";
      };
    }
    {
      mode = "n";
      key = "<leader>ov";
      action = "<cmd>ObsidianFollowLink vsplit<cr>";
      options = {
        desc = "Open the link under the cursor in vertical split";
      };
    }
    {
      mode = "n";
      key = "<leader>os";
      action = "<cmd>ObsidianFollowLink hsplit<cr>";
      options = {
        desc = "Open the link under the cursor in horizontal split";
      };
    }
    {
      mode = "n";
      key = "<leader>obl";
      action = "<cmd>ObsidianBacklinks<cr>";
      options = {
        desc = "Get a picker list of references to the current buffer.";
      };
    }
    {
      mode = "n";
      key = "<leader>ows";
      action = "<cmd>ObsidianWorkspace<cr>";
      options = {
        desc = "Switch to another workspace.";
      };
    }
    {
      mode = "n";
      key = "<leader>opi";
      action = "<cmd>ObsidianPasteImg<cr>";
      options = {
        desc = "Paste an image from the clipboard into the note at the cursor position by saving it to the vault and adding a markdown image link. You can configure the default folder to save images to with the attachments.img_folder option.";
      };
    }
    {
      mode = "n";
      key = "<leader>ot";
      action = "<cmd>ObsidianTags<cr>";
      options = {
        desc = "Search for notes by tag.";
      };
    }
    {
      mode = "n";
      key = "<leader>of";
      action = "<cmd>ObsidianSearch<cr>";
      options = {
        desc = "Search for notes by tag.";
      };
    }
  ];
}
