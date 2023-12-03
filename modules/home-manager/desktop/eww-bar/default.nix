{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.desktop.eww-bar;
in
{
  options.newborn.homeManagerModules.desktop.eww-bar = {
    enable = mkEnableOption "eww-based status bar";
    wm = mkOption {
      type = types.enum [ "sway" ];
      default = "sway";
      description = "The window manager to use";
    };
    swaymsgPath = mkOption {
      type = types.str;
      default = "${pkgs.sway}/bin/swaymsg";
      description = "The path to swaymsg";
    };
    menuCommand = mkOption {
      type = types.str;
      default = "${pkgs.rofi}/bin/rofi -show drun";
      description = "The command to run when the menu button is clicked";
    };
    networkCommand = mkOption {
      type = types.str;
      default = "${pkgs.foot}/bin/foot -F ${pkgs.networkmanager}/bin/nmtui";
      description = "The command to run when the network button is clicked";
    };
    audioCommand = mkOption {
      type = types.str;
      default = "${pkgs.pavucontrol}/bin/pavucontrol";
      description = "The command to run when the audio button is clicked";
    };
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
        eww-wayland
      ];

      xdg.configFile = {
        "eww-bar/eww.scss".source = ./eww.scss;
        "eww-bar/eww.yuck" = {
          text = replaceStrings [
            "nohup rofi -show drun &"
            "nohup foot -F nmtui &"
            "nohup pavucontrol &"
            "date '+%D'"
            "date '+%r'"
          ] [
            "${pkgs.coreutils}/bin/nohup ${cfg.menuCommand} &"
            "${pkgs.coreutils}/bin/nohup ${cfg.networkCommand} &"
            "${pkgs.coreutils}/bin/nohup ${cfg.audioCommand} &"
            "${pkgs.coreutils}/bin/date '+%D'"
            "${pkgs.coreutils}/bin/date '+%r'"
          ]
            (readFile ./eww.yuck);
        };
        "eww-bar/icons".source = ./icons;
        "eww-bar/scripts/subscribe-workspaces-widget.py" = {
          text = replaceStrings [
            "#!/usr/bin/env python3"
            "WORKSPACE_TOOL_COMMAND = environ.get(\"WORKSPACE_TOOL_COMMAND\")"
          ] [
            "#!${pkgs.python3}/bin/python3"
            "WORKSPACE_TOOL_COMMAND = \"${config.xdg.configHome}/eww-bar/scripts/${cfg.wm}_workspace-tool.py\""
          ]
            (readFile ./scripts/subscribe-workspaces-widget.py);
          executable = true;
        };
      };
    }

    (mkIf (cfg.wm == "sway") {
      xdg.configFile = {
        "eww-bar/scripts/sway_workspace-tool.py" = {
          text = replaceStrings [
            "#!/usr/bin/env python3"
            "SWAYMSG_PATH = \"swaymsg\""
          ] [
            "#!${pkgs.python3}/bin/python3"
            "SWAYMSG_PATH = \"${cfg.swaymsgPath}\""
          ]
            (readFile ./scripts/sway_workspace-tool.py);
          executable = true;
        };
      };
    })


    (mkIf cfg.systemd.enable {
      systemd.user.services.eww-bar = {
        Unit = {
          Description =
            "eww-based status bar";
          Documentation = "https://elkowar.github.io/eww";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session-pre.target" ];
        };

        Service = {
          Environment = "PATH=${pkgs.bash}/bin";
          ExecStart = "${pkgs.eww-wayland}/bin/eww daemon --no-daemonize -c ${config.xdg.configHome}/eww-bar";
          ExecStartPost = "${pkgs.eww-wayland}/bin/eww open bar -c ${config.xdg.configHome}/eww-bar";
        };

        Install = { WantedBy = [ cfg.systemd.target ]; };
      };
    })
  ]);
}


