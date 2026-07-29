{ config, lib, pkgs, ... }:
{
  programs.niri.enable = true;
  programs.gpu-screen-recorder.enable = true;

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
        default = lib.mkForce [
          "wlr"
          "gtk"
        ];
      };
    };
  };
}
