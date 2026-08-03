{ config, lib, pkgs, ... }:
{
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = false;
  };

  services.orca.enable = false;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    elisa
    khelpcenter
    krdp
    discover
  ];

  home-manager.users.hazem.programs.plasma = {
    enable = true;
    input.keyboard = {
      layouts = [
        { layout = "us"; }
        { layout = "ar"; }
      ];
      options = [ "grp:alt_shift_toggle" ];
    };
    configFile.kwalletrc."Wallet"."Enabled" = false;
  };
}
