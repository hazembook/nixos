{ config, lib, pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;

  # Handles both Plasma and Niri sessions (choose at login).
  services.displayManager.plasma-login-manager.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    elisa
  ];
}
