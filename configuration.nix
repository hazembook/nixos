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

  # Boot logs enabled, ACPI errors suppressed
  boot.kernelParams = [
    "systemd.show_status=1"
    "loglevel=2"
  ];

  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass hazem as root
    '';
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Tripoli";

  services.keyd = {
    enable = true;
    keyboards = {
      defaults = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(control, esc)";
            esc = "capslock";
          };
        };
      };
    };
  };

  # Light, fast display manager
  services.displayManager.ly.enable = true;

  # Enable Niri compositor
  programs.niri.enable = true;
  programs.gpu-screen-recorder.enable = true;

  # Polkit daemon (essential for Wayland session permissions)
  security.polkit.enable = true;

  # Sound settings via Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Portal configuration for Niri & Wayland screen recording
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "wlr"
          "gtk"
        ];
      };
      niri = {
        # lib.mkForce overrides Niri's built-in default ("gnome;gtk")
        default = lib.mkForce [
          "wlr"
          "gtk"
        ];
      };
    };
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

  # System-wide fonts (JetBrains Mono + Amiri for Hijri Widget)
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    amiri
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
