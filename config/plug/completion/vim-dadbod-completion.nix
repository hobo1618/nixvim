{ pkgs, config, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "vim-dadbod-completion";
      version = "1.0";
      src = pkgs.fetchFromGitHub {
        owner = "kristijanhusak";
        repo = "vim-dadbod-ui";
        rev = "04485bfb53a629423233a4178d71cd4f8abf7406";
        hash = "sha256-vcnECBKjEt/iz8WSUI0jJBxasy7cRuCQcaQayHXydrE=";
      };
    })
  ];
}
