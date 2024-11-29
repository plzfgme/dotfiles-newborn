{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.desktop.sway;
in
{
  options.newborn.homeManagerModules.desktop.sway = {
    enable = mkEnableOption "sway with setup configuration";
    terminal = mkOption {
      type = types.str;
      default = "${pkgs.foot}/bin/foot";
      description = "Terminal to use";
    };
    menu = mkOption {
      type = types.str;
      default = "${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
      description = "Menu to use";
    };
    startup = mkOption {
      type = with types; listOf attrs;
      default = [ ];
      description = "Pass to wayland.windowManager.sway.config.startup";
    };
    extraKeybindings = mkOption {
      type = types.attrs;
      default = {};
      description = "Extra keybindings";
    };
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra sway configuration";
    };
    extraConfigEarly = mkOption {
      type = types.lines;
      default = "";
      description = "Extra sway configuration (before other configuration)";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod4";
        left = "h";
        down = "j";
        up = "k";
        right = "l";
        terminal = cfg.terminal;
        menu = cfg.menu;

        keybindings =
          let
            modifier = config.wayland.windowManager.sway.config.modifier;
            left = config.wayland.windowManager.sway.config.left;
            down = config.wayland.windowManager.sway.config.down;
            up = config.wayland.windowManager.sway.config.up;
            right = config.wayland.windowManager.sway.config.right;
          in
          {
            # Launch terminal
            "${modifier}+Return" = "exec ${cfg.terminal}";

            # Launch menu
            "${modifier}+d" = "exec ${cfg.menu}";

            # Kill focused window
            "${modifier}+q" = "kill";

            # Move focus
            "${modifier}+${left}" = "focus left";
            "${modifier}+${down}" = "focus down";
            "${modifier}+${up}" = "focus up";
            "${modifier}+${right}" = "focus right";

            # Move focused window
            "${modifier}+Shift+${left}" = "move left";
            "${modifier}+Shift+${down}" = "move down";
            "${modifier}+Shift+${up}" = "move up";
            "${modifier}+Shift+${right}" = "move right";

            # Workspace navigation
            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+0" = "workspace number 10";

            # Move focused window to workspace
            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "${modifier}+Shift+0" = "move container to workspace number 10";

            # Split orientation
            "${modifier}+b" = "splith";
            "${modifier}+v" = "splitv";

            # Layout
            "${modifier}+s" = "layout stacking";
            "${modifier}+w" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";

            # Toggle fullscreen
            "${modifier}+f" = "fullscreen toggle";

            # Toggle floating
            "${modifier}+Shift+space" = "floating toggle";

            # Select parent
            "${modifier}+a" = "focus parent";

            # Scratchpad
            "${modifier}+Shift+minus" = "move scratchpad";
            "${modifier}+minus" = "scratchpad show";

            # Enter resize mode
            "${modifier}+r" = "mode \"resize\"";
          } // cfg.extraKeybindings;

        modes = {
          resize =
            let
              left = config.wayland.windowManager.sway.config.left;
              down = config.wayland.windowManager.sway.config.down;
              up = config.wayland.windowManager.sway.config.up;
              right = config.wayland.windowManager.sway.config.right;
            in
            {
              "${left}" = "resize shrink width 10 px";
              "${down}" = "resize grow height 10 px";
              "${up}" = "resize shrink height 10 px";
              "${right}" = "resize grow width 10 px";

              # Return to default mode
              "Return" = "mode \"default\"";
              "Escape" = "mode \"default\"";
            };
        };

        floating = {
          modifier = "${config.wayland.windowManager.sway.config.modifier} normal";
        };

        window.titlebar = false;

        bars = [ ];

        colors = {
          focused = {
            border = "#${config.colorScheme.palette.base0D}";
            background = "#${config.colorScheme.palette.base02}";
            text = "#${config.colorScheme.palette.base0D}";
            indicator = "#${config.colorScheme.palette.base0D}";
            childBorder = "#${config.colorScheme.palette.base0D}";
          };
        };

        startup = cfg.startup;

        defaultWorkspace = "workspace number 1";
      };
      extraConfig = cfg.extraConfig;
      extraConfigEarly = cfg.extraConfigEarly;
    };
  };
}

