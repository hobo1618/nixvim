{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "marp-nvim";
      version = "1.0";
      src = pkgs.fetchFromGitHub {
        owner = "mpas";
        repo = "marp-nvim";
        rev = "4f38e6ffe2f5ea260f35f7ff3e4e424b9f8bea29";
        hash = "sha256-CebyoqIBi8xT5U+aCBwptOSz89KxhXS27kAtPrRZvT8=";
      };
    })
  ];

  extraConfigLua = ''
    require('marp').setup({
      port = 8080
      wait_for_response_timeout = 30,
      wait_for_response_delay = 1,
    })
  '';
}

