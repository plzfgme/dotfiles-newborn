{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.programs.bat;
in
{
  options.newborn.homeManagerModules.programs.bat = {
    enable = mkEnableOption "bat with setup configuration";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        theme = "tokyo-night";
      };
      themes = {
        tokyo-night = {
          src = ./tokyo-night;
          file = "tokyoNight.tmTheme";
        };
      };
    };
  };
}


