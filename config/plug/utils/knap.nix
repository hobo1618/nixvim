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

  extraConfigLua = ''
    -- set shorter name for keymap function
    local kmap = vim.keymap.set
    
    -- F5 processes the document once, and refreshes the view
    kmap({ 'n', 'v', 'i' },'<F5>', function() require("knap").process_once() end)
    
    -- F6 closes the viewer application, and allows settings to be reset
    kmap({ 'n', 'v', 'i' },'<F6>', function() require("knap").close_viewer() end)
    
    -- F7 toggles the auto-processing on and off
    kmap({ 'n', 'v', 'i' },'<F7>', function() require("knap").toggle_autopreviewing() end)
    
    -- F8 invokes a SyncTeX forward search, or similar, where appropriate
    kmap({ 'n', 'v', 'i' },'<F8>', function() require("knap").forward_jump() end)
    texoutputext = "pdf"
    textopdf = "pdflatex -synctex=1 -halt-on-error -interaction=batchmode %docroot%"
    textopdfviewerlaunch = "mupdf %outputfile%"
    textopdfviewerrefresh = "kill -HUP %pid%"
  '';
}
