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
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # My modules
  newborn.homeManagerModules = {
    programs.alacritty = {
      enable = true;
      extraSettings = {
        env.WINIT_X11_SCALE_FACTOR = "1.0";
        font.size = 16;
      };
    };
    programs.nushell.enable = true;
    programs.zsh.enable = true;
    programs.starship.enable = true;
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
    programs.kitty = {
      enable = true;
    };

    collections.basic-cmd-tools.enable = true;
  };

  # Color scheme
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # Packages
  home = {
    username = "plzfgme";
    homeDirectory = "/home/plzfgme";
    packages = with pkgs; [
      nil
      nixpkgs-fmt
      marksman
      markdownlint-cli
      bitwarden-cli
      nodejs_22 # copilot.vim
      yazi
      bottom
      tldr
      tmux
      ncdu
      xdg-utils
    ];
  };
  programs.home-manager.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
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

  home.stateVersion = "24.11";
}

