{ config, lib, pkgs, inputs, ... }:
{
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = false;
  };

  services.displayManager.plasma-login-manager.enable = true;

  services.orca.enable = false;

  security.pam.services.kde.kwallet.enable = false;
  security.pam.services.login.kwallet.enable = false;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    elisa
    khelpcenter
    krdp
    discover
  ];

  home-manager.users.hazem.imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

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
