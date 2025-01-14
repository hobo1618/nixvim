{ pkgs, config, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "vim-dadbod";
      version = "1.0";
      src = pkgs.fetchFromGitHub {
        owner = "tpope";
        repo = "vim-dadbod";
        rev = "fe5a55e92b2dded7c404006147ef97fb073d8b1b";
        hash = "sha256-wRkd6DRpjDvazJrjbIAndNrnjMIrKOGKQvNfnk+9yeM=";
      };
    })
  ];
}
