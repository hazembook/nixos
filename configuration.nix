{
  config,
  lib,
  pkgs,
  inputs, # Accepted inputs from specialArgs
  ...
}:

{
  imports = [
    inputs.noctalia.nixosModules.default
  ] ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix;

  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass hazem as root
    '';
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lenovo-v145";
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

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  # Printing
  services.printing.enable = true;

  users.users.hazem = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "libvirt"
      "docker"
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    # Core system
    vim wget git wl-clipboard brightnessctl

    # Shell & terminal tools
    jq curl ripgrep fd fzf trash-cli unzip unrar p7zip zstd glow

    # Editor: Neovim
    neovim nodejs

    # Language Servers
    lua-language-server nil nixpkgs-fmt bash-language-server
    clang-tools gopls pyright ruff
    texlab tinymist zls deno
    vscode-langservers-extracted

    # Editor: Emacs (from emacs-overlay, Wayland-native)
    emacs30-pgtk

    # Development toolchain
    go rustup zoxide atuin yt-dlp entr kubectl catt
    jdk17 android-tools
    lazygit python3 black pipenv python3Packages.pytest
    ruby rubocop ruby-lsp
    gotests gore gomodifytags
    delve zig ktlint nixfmt shfmt shellcheck
    pandoc

    # Build tools
    gcc gnumake ffmpeg tectonic zathura
    tree

    # Virtualisation tools
    libvirt virt-manager qemu cloud-utils

    # Container runtimes
    docker podman

    # VM deployment dependencies
    openssl

    # Wayland screenshot
    slurp grim

    # Process management (killall, fuser, pstree, pidof)
    psmisc

    # Network monitoring
    nethogs

    # Browser
    chromium
  ];

  # Add emacs-overlay for modern Emacs builds
  nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];

  # System-wide fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only  # Doom Emacs icons & fallback glyphs
    amiri                     # Hijri Widget
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
