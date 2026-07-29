{ config, lib, pkgs, inputs, ... }:
{
  imports = [ inputs.noctalia.nixosModules.default ];

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  home-manager.users.hazem.imports = [ inputs.noctalia.homeModules.default ];
}
