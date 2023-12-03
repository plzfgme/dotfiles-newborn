{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.desktop.swww;
in
{
  options.newborn.homeManagerModules.desktop.swww = {
    enable = mkEnableOption "swww with setup configuration";
    systemd.enable = mkEnableOption "Enable systemd service";
    systemd.target = mkOption {
      type = types.str;
      default = "graphical-session.target";
      example = "sway-session.target";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [
        swww
      ];
      xdg.configFile."swww/default.jpg".source = ./wallpapers/default.jpg;
    }
    (mkIf cfg.systemd.enable {
      systemd.user.services.swww = {
        Unit = {
          Description =
            "swww: A Solution to your Wayland Wallpaper Woes";
          Documentation = "https://github.com/Horus645/swww";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session-pre.target" ];
        };

        Service = {
          Type = "oneshot";
          Environment = "PATH=${pkgs.swww}/bin";
          RemainAfterExit = true;
          ExecStart = "${pkgs.swww}/bin/swww init";
          ExecStartPost = "${pkgs.swww}/bin/swww img ${config.xdg.configHome}/swww/default.jpg";
          ExecStop = "${pkgs.swww}/bin/swww kill";
          Restart = "on-failure";
        };

        Install = { WantedBy = [ cfg.systemd.target ]; };
      };
    })
  ]);
}

