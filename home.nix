{
  config,
  pkgs,
  inputs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory mappings
  configs = {
    nvim = "nvim";
    fish = "shells/fish";
    niri = "niri";
    noctalia = "noctalia";
  };
in

{
  home.username = "hazem";
  home.homeDirectory = "/home/hazem";
  programs.git.enable = true;
  home.stateVersion = "26.05";

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      if [ -f ${dotfiles}/shells/bash/.bashrc ]; then
        source ${dotfiles}/shells/bash/.bashrc
      fi
    '';
  };

  imports = [
    ./modules/neovim.nix
    # Import Noctalia user options
    inputs.noctalia.homeModules.default
  ];

  # Map your configs to ~/.config
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
  }) configs;

  home.packages = with pkgs; [
    # Shell & multiplexer environment
    tmux
    fish
    starship
    lsd
    ghostty

    # Utilities
    htop
    btop
    yazi
    fastfetch
    jq
    curl

    # Compiler tools needed by lazy.nvim
    gcc
    gnumake

    # Required for Noctalia Screen Recoder Plugin
    ffmpeg
    slurp
    grim
  ];
}
