{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = outputs.homeManagerModules.allModules ++ [
    inputs.nix-colors.homeManagerModules.default
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
      terminal = "env -u WAYLAND_DISPLAY alacritty -e env WAYLAND_DISPLAY=$WAYLAND_DISPLAY $SHELL";
      extraKeybindings = {
        "Mod4+Shift+a" = "exec bash -c \"wl-paste | clitrans --to zh-CN --preprocessors remove_newlines | pointersay\"";
        "Mod4+Shift+z" = "exec bash -c 'grim -g \"$(slurp)\" - | tesseract stdin stdout | clitrans --to zh-CN --preprocessors remove_newlines | pointersay'";
      };
      extraConfig = ''
        output Virtual-1 resolution 1920x1080
      '';
      startup = [
        { command = "nm-applet"; }
        { command = "thunderbird"; }
      ];
    };
    desktop.eww-bar = {
      enable = true;
      systemd.enable = true;
    };
    desktop.swww = {
      enable = true;
      systemd.enable = true;
    };

    programs.alacritty = {
      enable = true;
      extraSettings = {
        env.WINIT_X11_SCALE_FACTOR = "1.0";
      };
    };
    programs.foot.enable = true;
    programs.nushell.enable = true;
    programs.zsh.enable = true;
    programs.starship.enable = true;
    programs.neovim.enable = true;
    programs.rofi.enable = true;

    collections.basic-cmd-tools.enable = true;
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
    sessionVariables = {
      http_proxy = "http://localhost:7890";
      https_proxy = "http://localhost:7890";
    };
    packages = with pkgs; [
      nil
      nixpkgs-fmt
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
      inputs.pointersay.packages.x86_64-linux.default
      inputs.clitrans.packages.x86_64-linux.default
      nodejs_21 # copilot.vim
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
    ];
  };
  programs.home-manager.enable = true;
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
