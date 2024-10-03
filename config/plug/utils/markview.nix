{
  plugins.markview = {
    enable = true;

    settings =
      {
        modes = [
          "n"
          "no"
          "c"
        ];
        hybrid_modes = [ "n" ];
        callback.on_enable.__raw = ''
          function (_, win)
            vim.wo[win].conceallevel = 2;
            vim.wo[win].concealcursor = "c";
          end
        '';
      };
  };
}
