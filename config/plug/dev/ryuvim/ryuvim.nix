{ pkgs, ... }:
{
  extraFiles =
    {
      "lua/ryudev.lua" = {
        source = ./ryudev/init.lua;
      };
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

  extraConfigLua = ''
    -- require('ryuvim').setup()
    require('ryudev')
  '';

}
