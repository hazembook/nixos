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

  services.displayManager.ly.enable = false;

  services.displayManager = {
    plasma-login-manager.enable = true;
    autoLogin = {
      enable = true;
      user = "hazem";
    };
    defaultSession = "niri";
  };

  home-manager.users.hazem.home.packages = with pkgs; [
    # Backlight
    brightnessctl

    # Clipboard
    wl-clipboard xclip

    # Screenshot
    slurp grim
  ];

  fonts.packages = with pkgs; [
    amiri
  ];
}
