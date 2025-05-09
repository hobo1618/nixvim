{ pkgs, ... }:
let
  mdxGrammar = pkgs.tree-sitter.overrideAttrs (oldAttrs: {
    pname = "tree-sitter-mdx";
    version = "unstable-2024-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "stone-z";
      repo = "treesitter-mdx";
      rev = "6f5a6e3e32b0c89824f157cfa2a972207f20b5e3";
      sha256 = "sha256-9zZ+tb7v9V9M3h1QlNcs1IMOm2ztJd4Z2NEcXqXAOE4=";
    };
  });
in
{
  filetype.extension = {
    liq = "liquidsoap";
    mdx = "mdx"; # 👈 ensures .mdx files are detected
  };

  plugins.treesitter = {
    enable = true;

    settings = {
      indent.enable = true;
      highlight.enable = true;
    };

    folding = true;
    languageRegister = {
      liq = "liquidsoap";
      mdx = "mdx";
    };

    nixvimInjections = true;

    grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars // {
      mdx = mdxGrammar;
    };
  };

  extraConfigLua = ''
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    parser_config.liquidsoap = {
      filetype = "liquidsoap",
    }
  '';
}



# { pkgs, ... }:
# {
#   filetype.extension.liq = "liquidsoap";
#
#   plugins.treesitter = {
#     enable = true;
#
#     settings = {
#       indent = {
#         enable = true;
#       };
#       highlight = {
#         enable = true;
#       };
#     };
#
#     folding = true;
#     languageRegister.liq = "liquidsoap";
#     nixvimInjections = true;
#     grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
#   };
#
#   extraConfigLua = ''
#     local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
#
#     parser_config.liquidsoap = {
#       filetype = "liquidsoap",
#     }
#   '';
# }
