{ pkgs, config, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "cmp-vimtex";
      version = "1.0";
      src = pkgs.fetchFromGitHub {
        owner = "micangl";
        repo = "cmp-vimtex";
        rev = "5283bf9108ef33d41e704027b9ef22437ce7a15b";
        hash = "sha256-pD2dPdpyn5A/uwonDdAxCX138yBeDqbXDdlG/IKjVTU=";
      };
    })
  ];
}
