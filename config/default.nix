{ config, lib, ... }:
{
  imports = [
    ./autocommands.nix
    ./keys.nix
    ./sets.nix
    ./highlight.nix

    ./plug/colorscheme/colorscheme.nix

    ./plug/completion/cmp-vimtex.nix
    ./plug/completion/cmp.nix
    ./plug/completion/codecompanion.nix
    ./plug/completion/copilot-cmp.nix
    ./plug/completion/lspkind.nix
    ./plug/completion/schemastore.nix
    ./plug/completion/vim-dadbod-completion.nix

    ./plug/git/gitlinker.nix
    ./plug/git/gitsigns.nix
    ./plug/git/lazygit.nix
    ./plug/git/worktree.nix

    ./plug/lsp/conform.nix
    ./plug/lsp/fidget.nix
    ./plug/lsp/lsp.nix
    ./plug/lsp/lspsaga.nix
    ./plug/lsp/none-ls.nix
    ./plug/lsp/vimtex.nix
    ./plug/lsp/trouble.nix
    ./plug/lsp/mdx.nix

    ./plug/snippets/luasnip.nix

    ./plug/statusline/lualine.nix
    #./plug/statusline/staline.nix

    ./plug/treesitter/treesitter-context.nix
    ./plug/treesitter/treesitter-textobjects.nix
    ./plug/treesitter/treesitter.nix

    ./plug/ui/alpha.nix
    # ./plug/ui/btw.nix
    ./plug/ui/bufferline.nix
    ./plug/ui/dressing.nix
    ./plug/ui/indent-blankline.nix
    # ./plug/ui/ryuvim.nix
    ./plug/ui/noice.nix
    ./plug/ui/nvim-notify.nix
    ./plug/ui/vim-dadbod-ui.nix
    #./plug/ui/precognition.nix
    ./plug/ui/telescope.nix

    ./plug/utils/harpoon.nix
    ./plug/utils/comment.nix
    ./plug/utils/comment-box.nix
    ./plug/utils/flash.nix
    ./plug/utils/grapple.nix
    ./plug/utils/knap.nix
    ./plug/utils/marp-nvim.nix
    ./plug/utils/hardtime.nix
    ./plug/utils/illuminate.nix
    ./plug/utils/markview.nix
    ./plug/utils/markdown-preview.nix
    ./plug/utils/mini.nix
    ./plug/utils/obsidian.nix
    ./plug/utils/oil.nix
    ./plug/utils/ufo.nix
    ./plug/utils/undotree.nix
    ./plug/utils/vim-dadbod.nix
    ./plug/utils/whichkey.nix
    ./plug/utils/yaml-companion.nix

    ./plug/dev/ryuvim_dev/ryuvim.nix
  ];
  options = {
    theme = lib.mkOption {
      default = lib.mkDefault "paradise";
      type = lib.types.enum [
        "paradise"
        "decay"
        "edge-dark"
        "mountain"
        "tokyonight"
        "everforest"
        "everblush"
        "jellybeans"
        "aquarium"
        "gruvbox"
      ];
    };
    assistant = lib.mkOption {
      default = "none";
      type = lib.types.enum [
        "copilot"
        "none"
      ];
    };
  };
  config = {
    # The base16 theme to use, if you want to use another theme, change it in colorscheme.nix
    theme = "paradise";
    extraConfigLua = ''
      _G.theme = "${config.theme}"
      require("mdx").setup()
    '';
  };
}
