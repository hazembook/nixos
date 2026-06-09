{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  # Standard .config/directory
  configs = {
    qtile = "qtile";
    nvim = "nvim";
    fish = "shells/fish";
  };
in

{
  home.username = "hazem";
  home.homeDirectory = "/home/hazem";
  programs.git.enable = true;
  home.stateVersion = "26.05";
  programs.bash = {
    enable = true;
    # Safely source your custom .bashrc at the end of Home Manager's generated file
    bashrcExtra = ''
      if [ -f ${dotfiles}/shells/bash/.bashrc ]; then
        source ${dotfiles}/shells/bash/.bashrc
      fi
    '';
  };

  imports = [
    ./modules/neovim.nix
  ];

  # Iterate over xdg configs and map them accordingly
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
  }) configs;

  home.packages = with pkgs; [
    tmux
    gcc
    gnumake
    htop
    btop
    starship
    fish
    lsd
  ];
}
