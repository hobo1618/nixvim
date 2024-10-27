{ pkgs, ... }:
{

  extraFiles =
    {
      "lua/print_command.lua" = {
        source = ../../../../lua/print_command.lua;
        # source = ../../../lua/print_command.lua;
      };
    };

  # {
  #   "lua/ryuvim_dev.lua" = {
  #     source = ../../../lua/ryuvim-dev.lua;
  #   };
  # };
  # extraFiles =
  #   {
  #     "lua/print_command.lua" = {
  #       text = ''
  #         print("Hello from foo")
  #         vim.api.nvim_create_user_command("SayHello", function()
  #         	print("Hello from nixvim!")
  #         end, {})
  #       '';
  #       enable = true;
  #     };
  #   };

  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "ryuvim";
      version = "1.0";
      src = pkgs.fetchFromGitHub {
        owner = "hobo1618";
        repo = "ryuvim";
        rev = "5e5d0599eee16741c1ae24a2090df4f87fb7640a";
        hash = "sha256-K1dr3qLnuSK8AhE1jgcITgukeVY7jrwjsX9Xttahoks=";
      };
    })
  ];

  extraConfigLua = ''
    require('ryuvim').setup()
    -- require('ryuvim_dev')
    require('print_command')
  '';

}
