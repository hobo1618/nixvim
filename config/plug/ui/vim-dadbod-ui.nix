{ pkgs, config, ... }:
{
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "vim-dadbod-ui";
      version = "1.0";
      src = pkgs.fetchFromGitHub {
        owner = "kristijanhusak";
        repo = "vim-dadbod-ui";
        rev = "7f89265a84fc003ccfa500fd99b9fea9db2c75c7";
        hash = "sha256-FjdspE1vwEsmNmeZc9PaGNxS8LXeaX2UainwjaW8F/w=";
      };
    })
  ];
}
