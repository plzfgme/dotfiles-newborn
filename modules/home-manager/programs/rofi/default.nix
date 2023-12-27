{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.programs.rofi;
in
{
  options.newborn.homeManagerModules.programs.rofi = {
    enable = mkEnableOption "rofi with setup configuration";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      extraConfig = {
        modi= "drun";
        icon-theme = "Oranchelo";
        show-icons = true;
        terminal = "alacritty";
        drun-display-format= "{icon} {name}";
        location= 0;
        disable-history= false;
        hide-scrollbar= true;
        display-drun= "   Apps ";
        sidebar-mode= true;
      };
      theme = ./theme.rasi;
    };
  };
}
