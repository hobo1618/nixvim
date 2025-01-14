{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "mdx.nvim";
      version = "61b93f6";
      src = pkgs.fetchFromGitHub {
        owner = "davidmh";
        repo = "mdx.nvim";
        rev = "61b93f6576cb5229020723c7a81f5a01d2667d05";
        hash = "sha256-CYcL+s1634UgquwUYp70iAD2xC6r87j6w5jYv90mUAg=";
      };
    })
  ];
}
