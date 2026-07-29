{ config, lib, pkgs, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];

  home-manager.users.hazem.home.packages = with pkgs; [
    neovim nodejs python3 
    emacs30-pgtk

    lua-language-server nil nixpkgs-fmt bash-language-server
    clang-tools gopls pyright ruff
    texlab tinymist zls deno
    vscode-langservers-extracted tree-sitter biber

    black pipenv python3Packages.pytest
    zig ktlint nixfmt shfmt shellcheck

    texliveSmall
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
   ];
}
