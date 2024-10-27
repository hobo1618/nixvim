{ pkgs, ... }:
{
  extraFiles = {
    # Specify the source file and its destination in Neovim’s runtime path
    # "lua/print_command.lua".source = "./lua/print_command.lua";
    "ftplugin/print_command.lua".text = "vim.api.nvim_create_user_command('SayHello', function() print('Hello from nixvim!') end, {}) ";
  };


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
  #
  # extraConfigLua = ''
  #   require('ryuvim').setup()
  # '';

}
