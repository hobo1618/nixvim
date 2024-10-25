{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "ryuvim";
      version = "0.1.0";
      src = pkgs.fetchFromGitHub {
        owner = "hobo1618";
        repo = "ryuvim";
        rev = "2f4e1e45cf332d5f294eb95409ac3c967cf7c224";
        hash = "sha256-T8Uyu8py8SoI9FXRsoJaSoj9Ygv6AqUqDTuzcgwRFew=";
      };
    })
  ];
}
