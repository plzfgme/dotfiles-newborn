{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.services.mako;
in
{
  options.newborn.homeManagerModules.services.mako = {
    enable = mkEnableOption "mako";
  };

  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      extraConfig = ''
        width=400
        height=1000

        # Colors from https://github.com/catppuccin/mako/blob/main/src/mocha
        background-color=#1e1e2e
        text-color=#cdd6f4
        border-color=#89b4fa
        progress-color=over #313244

        [urgency=high]
        border-color=#fab387
      '';
      layer = "overlay";
    };
  };
}
