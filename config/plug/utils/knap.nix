{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "knap";
      version = "1.0";
      src = pkgs.fetchFromGitHub {
        owner = "frabjous";
        repo = "knap";
        rev = "7db44d0bb760120142cc1e8f43e44976de59c2f6";
        hash = "sha256-BX/y1rEcDqj96rDssWwrMbj93SVIfFCW3tFgsFI1d4M=";
      };
    })
  ];
}
