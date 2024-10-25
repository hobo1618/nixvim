{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "ryuvim";
      version = "v0.0.1";
      src = pkgs.fetchFromGitHub {
        owner = "hobo1618";
        repo = "ryuvim";
        rev = "9f124ac7cfc4b2a0221deaa8f8326c37b505f6e6";
        hash = "sha256-qn2TRk/ERdhh8t86ZvlY0UbiTIFkdDcG8cutyCuekxw=";
      };
    })
  ];
}
