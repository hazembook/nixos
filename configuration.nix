{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./modules/editors.nix
    ./modules/services.nix
    ./modules/desktop/base.nix
    ./modules/desktop/niri.nix
    ./modules/desktop/plasma.nix
    ./modules/desktop/noctalia.nix
  ] ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix;

  networking.hostName = "lenovo-v145";
  networking.networkmanager.enable = true;

  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "hazem" ];
      keepEnv = true;
      noPass = true;
    }];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Africa/Tripoli";

  programs.fish.enable = true;

  programs.nix-ld.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.containers.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  programs.firefox.enable = true;

  users.users.hazem = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "libvirt"
      "docker"
    ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  environment.systemPackages = with pkgs; [
    gcc gnumake git wget vim psmisc
    cmake binutils gdb pkg-config
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
