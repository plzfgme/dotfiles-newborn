{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default

    outputs.homeManagerModules.allModules
  ];

  # Nix
  nixpkgs = {
    overlays = [
      inputs.rust-overlay.overlays.default
      inputs.eww.overlays.default
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # My modules
  newborn.homeManagerModules = {
    desktop.sway = {
      enable = true;
      # Before this pull request to be merged: https://github.com/swaywm/sway/pull/7226, input method on sway only works with XWayland.
      terminal = "env -u WAYLAND_DISPLAY kitty -e env WAYLAND_DISPLAY=$WAYLAND_DISPLAY $SHELL";
      menu = "rofi -show drun";
      extraKeybindings = {
        "Mod4+Shift+a" = "exec bash -c 'wl-paste | wl_translation_window --from-lang auto --to-lang zh-CN'";
        "Mod4+Shift+z" = "exec bash -c 'grim -g \"$(slurp)\" - | tesseract stdin stdout | wl_translation_window --from-lang auto --to-lang zh-CN'";
      };
      extraConfig = ''
        output eDP-1 mode 2560x1600@60.01Hz scale 1.2
      '';
      startup = [
        { command = "nm-applet"; }
        { command = "blueman-applet"; }
        { command = "thunderbird"; }
        { command = "discord"; }
        # { command = "telegram-desktop"; }
        { command = "qq"; }
        { command = "element-desktop"; }
      ];
    };

    desktop.i3 = {
      enable = true;
      terminal = "alacritty";
      menu = "rofi -show drun";
      extraKeybindings = {
        "Mod4+Shift+a" = "exec bash -c 'wl-paste | wl_translation_window --from-lang auto --to-lang zh-CN'";
        "Mod4+Shift+z" = "exec bash -c 'grim -g \"$(slurp)\" - | tesseract stdin stdout | wl_translation_window --from-lang auto --to-lang zh-CN'";
      };
      # extraConfig = ''
      #   output eDP-1 mode 2560x1600@60.01Hz scale 1.2
      # '';
      startup = [
        { command = "nm-applet"; }
        { command = "blueman-applet"; }
        { command = "thunderbird"; }
        { command = "discord"; }
        # { command = "telegram-desktop"; }
        { command = "qq"; }
        { command = "element-desktop"; }
      ];
    };

    desktop.eww-bar = {
      enable = true;
      systemd.enable = true;
      display = {
        resolution = {
          x = 2560;
          y = 1600;
        };
        scale = 1.2;
      };
    };
    desktop.swww = {
      enable = true;
      systemd.enable = true;
    };
    programs.alacritty = {
      enable = true;
      extraSettings = {
        env.WINIT_X11_SCALE_FACTOR = "1.0";
        font.size = 16;
      };
    };
    programs.foot.enable = true;
    programs.nushell.enable = true;
    programs.zsh.enable = true;
    programs.starship.enable = true;
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
    programs.rofi.enable = true;
    programs.kitty = {
      enable = true;
    };

    collections.basic-cmd-tools.enable = true;

    services.mako.enable = true;
  };

  # Color scheme
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  # Desktop
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
  gtk.enable = true;

  # Fcitx
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk
        libsForQt5.fcitx5-qt

        fcitx5-chinese-addons
        fcitx5-mozc
      ];
    };
  };


  # Packages
  home = {
    username = "plzfgme";
    homeDirectory = "/home/plzfgme";
    packages = with pkgs; [
      nil
      nixpkgs-fmt
      vscode
      marksman
      markdownlint-cli
      bitwarden
      bitwarden-cli
      okular
      inputs.nixpkgs-23_11.legacyPackages.x86_64-linux.zotero # CVE issue
      wl-clipboard
      xclip
      qq
      libreoffice
      xfce.thunar
      inputs.wl_translation_window.packages.x86_64-linux.default
      nodejs_22 # copilot.vim
      grim
      slurp
      tesseract
      anki
      microsoft-edge-dev
      telegram-desktop
      neovide
      yazi
      bottom
      tldr
      vlc
      tmux
      thunderbird
      networkmanagerapplet
      steam
      discord
      qq
      ncdu
      distrobox
      element-desktop
      (lutris.override {
        extraPkgs = pkgs: [
        ];
        extraLibraries = pkgs: [
        ];
      })
      wine
      xdg-utils
      gamescope
      prismlauncher
      config.nur.repos.linyinfeng.wemeet
      zed-editor
    ];

    pointerCursor = {
      package = pkgs.vanilla-dmz;
      gtk.enable = true;
      x11.enable = true;
      name = "Vanilla-DMZ";
      size = 24;
    };

    # sessionVariables = {
    # NIXOS_OZONE_WL = "1"; # https://nixos.wiki/wiki/Wayland
    # };
  };
  programs.home-manager.enable = true;
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition-bin;
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };
  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight_storm";
    };
  };
  xdg.configFile."nvim/lua/plugins/lsp.lua".source = ./dot_config/nvim/lua/plugins/lsp.lua;
  xdg.configFile."nvim/lua/config/lazy.lua".source = lib.mkForce ./dot_config/nvim/lua/config/lazy.lua;
  xdg.configFile."nvim/lua/config/options.lua".source = lib.mkForce ./dot_config/nvim/lua/config/options.lua;
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  services.udiskie.enable = true;

  # Git
  programs.git = {
    enable = true;
    package = pkgs.gitSVN;
    userName = "plzfgme";
    userEmail = "plzfgme@gmail.com";
    # signing.signByDefault = true;
    extraConfig = {
      credential.helper = "store";
    };
  };

  # SSH and GPG
  programs.ssh.enable = true;
  services.ssh-agent.enable = true;
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11";
}

