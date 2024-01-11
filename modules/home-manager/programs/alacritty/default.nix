{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.programs.alacritty;
in
{
  options.newborn.homeManagerModules.programs.alacritty = {
    enable = mkEnableOption "alacritty with setup configuration";
    extraSettings = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        Extra settings to add to the alacritty configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./alacritty.toml)
        // cfg.extraSettings;
    };
  };
}

