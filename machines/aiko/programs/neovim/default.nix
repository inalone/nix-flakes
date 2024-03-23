{pkgs, ...}: let
  treesitterWithGrammars = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
in {
  home.packages = with pkgs; [
    stylua

    # runtime dependencies
    ripgrep
    fd

    # lsps
    lua-language-server
    marksman
    rust-analyzer-unwrapped
    vscode-langservers-extracted
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = [treesitterWithGrammars];
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };

  xdg.configFile."nvim/parser".source = "${pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  }}/parser";
}
