{
  config,
  lib,
  pkgs,
  inputs, # Accepted inputs from specialArgs
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    # Import Noctalia system services
    inputs.noctalia.nixosModules.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  # Light, fast display manager
  services.displayManager.ly.enable = true;

  # Enable Niri compositor
  programs.niri.enable = true;

  # Polkit daemon (essential for Wayland session permissions)
  security.polkit.enable = true;

  # Sound settings via Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable system services for Noctalia
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true; # Automatically manages UPower and Power profiles
  };

  services.openssh.enable = true;

  users.users.hazem = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    # Wayland / Niri helper utilities
    wl-clipboard
    brightnessctl
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
