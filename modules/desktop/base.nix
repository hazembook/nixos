{ config, lib, pkgs, ... }:
{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.polkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Lightweight display manager for standalone Niri setup.
  # Uncomment for a minimal Niri-only setup (KDE Plasma's SDDM handles both sessions).
  # services.displayManager.ly.enable = true;

  home-manager.users.hazem.home.packages = with pkgs; [
    brightnessctl
    wl-clipboard
    xclip
    slurp grim
  ];

  fonts.packages = with pkgs; [
    amiri
  ];
}
