{ pkgs, ... }:
{

  #  extraPlugins = with pkgs.vimUtils; [
  #    (buildVimPlugin {
  #      pname = "marp-nvim";
  #      version = "1.0";
  #      src = pkgs.fetchFromGitHub {
  #        owner = "hobo1618";
  #        repo = "marp-nvim";
  #        rev = "fc7f9ff9633b4421de4af251a861f5ef2c465846";
  #        hash = "sha256-ALDCeciLQCrlcuyn7bpFFWtaP42ccJxEssli6zUoHhM=";
  #      };
  #    })
  #  ];
  #
  #
  #  extraConfigLua = ''
  #    require('marp').setup({
  #      port = 8080,
  #      wait_for_response_timeout = 30,
  #      wait_for_response_delay = 1,
  #    })
  #  '';


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
      port = 8080,
      wait_for_response_timeout = 30,
      wait_for_response_delay = 1,
    })
  '';
}
