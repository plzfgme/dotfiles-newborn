{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.desktop.waybar;
  settings = {
    mainBar = {
      height = 30;
      spacing = 4;
      modules-left = [
        "sway/workspaces"
        "sway/mode"
        "sway/scratchpad"
      ];
      modules-center = [
        "sway/window"
      ];
      modules-right = [
        "idle_inhibitor"
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "tray"
        "clock"
      ];
      "sway/mode" = {
        format = "<span style=\"italic\">{}</span>";
      };
      "sway/scratchpad" = {
        format = "{icon} {count}";
        show-empty = false;
        format-icons = [ "" "" ];
        tooltip = true;
        tooltip-format = "{app}: {title}";
      };
      "sway/workspaces" = {
        format = "{icon}";
        format-icons = {
          default = "";
        };
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };
      tray = {
        spacing = 10;
      };
      clock = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%Y-%m-%d}";
      };
      cpu = {
        interval = 1;
        format = "{icon0} {icon1} {icon2} {icon3}";
        format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
      };
      temperature = {
        thermal-zone = 0;
        hwmon-path = "/sys/class/hwmon/hwmon0/temp1_input";
        critical-threshold = 80;
        format-critical = "{temperatureC}°C";
        format = "{temperatureC}°C";
      };
      battery = {
        states = {
          warning = 50;
          critical = 20;
        };
        format = "{icon}";
        format-icons = [ "" "" "" "" "" "" "" "" "" ];
      };
      network = {
        format-wifi = "{essid} {quality:03.0f}% {icon}";
        format-ethernet = "{icon}";
        tooltip-format = "via {gwaddr} {ifname}";
        format-linked = "";
        format-disconnected = "wifi";
        format-alt = "   ";
      };
      pulseaudio = {
        scroll-step = 1;
        format = "{volume}% {icon}";
        format-bluetooth = "{volume}% {icon}";
        format-bluetooth-muted = " {icon}";
        format-muted = "";
        format-icons = {
          headphone = "";
          "hands-free" = "";
          headset = "󰋎";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };
    };
  };
  style = ''
    @define-color base   #1e1e2e;
    @define-color mantle #181825;
    @define-color crust  #11111b;

    @define-color text     #cdd6f4;
    @define-color subtext0 #a6adc8;
    @define-color subtext1 #bac2de;

    @define-color surface0 #313244;
    @define-color surface1 #45475a;
    @define-color surface2 #585b70;

    @define-color overlay0 #6c7086;
    @define-color overlay1 #7f849c;
    @define-color overlay2 #9399b2;

    @define-color blue      #89b4fa;
    @define-color lavender  #b4befe;
    @define-color sapphire  #74c7ec;
    @define-color sky       #89dceb;
    @define-color teal      #94e2d5;
    @define-color green     #a6e3a1;
    @define-color yellow    #f9e2af;
    @define-color peach     #fab387;
    @define-color maroon    #eba0ac;
    @define-color red       #f38ba8;
    @define-color mauve     #cba6f7;
    @define-color pink      #f5c2e7;
    @define-color flamingo  #f2cdcd;
    @define-color rosewater #f5e0dc;


    * {
      border: none;
      border-radius: 0;
      font-family: JetBrainsMono Nerd Font, monospace, sans-serif;
      font-size: 14px;
      min-height: 0;
    }

    window#waybar {
      all: unset;
      background-color: @surface0;
    }

    #workspaces {
      background-color: @overlay0;
      border-radius: 2em;
      margin-left: 1em;
    }
  '';
in
{
  options.newborn.homeManagerModules.desktop.waybar = {
    enable = mkEnableOption "waybar with setup configuration";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = settings;
      style = style;
    };
  };
}
