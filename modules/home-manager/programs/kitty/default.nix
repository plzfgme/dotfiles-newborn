{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.programs.kitty;
in
{
  options.newborn.homeManagerModules.programs.kitty = {
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
    programs.kitty = {
      enable = true;
      settings = {
        background_opacity = "0.7";
      } // cfg.extraSettings;
      shellIntegration = {
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
      theme = "Tokyo Night";
      font = {
        name = "monospace";
        size = 16;
      };
    };
  };
}

