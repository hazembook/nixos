{ config, lib, pkgs, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];

  home-manager.users.hazem.home.packages = with pkgs; [
    # Editors
    neovim emacs30-pgtk

    # Runtimes
    nodejs python3 ruby

    # LSPs
    lua-language-server nil nixpkgs-fmt bash-language-server
    clang-tools pyright ruff
    texlab tinymist zls deno
    vscode-langservers-extracted

    # Formatting & linting
    black pipenv python3Packages.pytest
    zig ktlint nixfmt shfmt shellcheck
    tree-sitter biber
    rubocop

    # LaTeX
    texliveSmall

    # Go
    go gopls
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    symbola
  ];
}
