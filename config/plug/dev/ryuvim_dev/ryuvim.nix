{ pkgs, ... }:
{
  extraFiles =
    {
      "lua/ryuvim/init.lua" = {
        source = ./ryuvim/init.lua;
      };
      "lua/ryuvim/utils.lua" = {
        source = ./ryuvim/utils.lua;
      };
      "lua/ryuvim/commands/list.lua" = {
        source = ./ryuvim/commands/list.lua;
      };
      "lua/ryuvim/commands/query.lua" = {
        source = ./ryuvim/commands/query.lua;
      };
      "lua/ryuvim/commands/delete.lua" = {
        source = ./ryuvim/commands/delete.lua;
      };
      "lua/ryuvim/openai.lua" = {
        source = ./ryuvim/openai.lua;
      };
      "lua/ryuvim/commands/ask.lua" = {
        source = ./ryuvim/commands/ask.lua;
      };
    };
  #
  # This worked before modules
  # {
  #   "lua/ryuvim.lua" = {
  #     source = ./ryuvim/init.lua;
  #   };
  # };
  # {
  #   "lua/ryuvim/init.lua" = {
  #     source = ./ryuvim/init.lua;
  #   };
  # };

  # extraPlugins = with pkgs.vimUtils; [
  #   (buildVimPlugin {
  #     pname = "ryuvim";
  #     version = "1.0";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "hobo1618";
  #       repo = "ryuvim";
  #       rev = "5e5d0599eee16741c1ae24a2090df4f87fb7640a";
  #       hash = "sha256-K1dr3qLnuSK8AhE1jgcITgukeVY7jrwjsX9Xttahoks=";
  #     };
  #   })
  # ];

  extraConfigLua = ''
    require('ryuvim')
    require('ryuvim/utils')
    require('ryuvim/commands/list')
    require('ryuvim/openai')
  '';

}
