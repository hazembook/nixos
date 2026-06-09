{ pkgs, ... }:

{
  # Install Neovim and dependencies
  home.packages = with pkgs; [
  neovim
    # Tools required for Telescope
    ripgrep
    fd
    fzf

    # Language Servers
    lua-language-server
    nil # nix language server
    nixpkgs-fmt # nix formatter
    bash-language-server

    # Needed for lazy.nvim
    nodejs
  ];
}
