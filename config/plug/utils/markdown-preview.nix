{ lib, ... }:
{
  plugins.markdown-preview = {
    enable = true;
    settings = {
      auto_close = 0;
      combine_preview = 1;
      combine_preview_auto_refresh = 1;
    };
  };
}
