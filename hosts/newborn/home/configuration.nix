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
      terminal = "foot";
      extraConfig = ''
        output Virtual-1 resolution 1920x1080
      '';
    };
    # desktop.waybar.enable = true;
    desktop.eww-bar = {
      enable = true;
      systemd.enable = true;
    };

    programs.foot.enable = true;
    programs.nushell.enable = true;
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

  # Packages
  home = {
    username = "plzfgme";
    homeDirectory = "/home/plzfgme";
    packages = with pkgs; [
      nil
      nixpkgs-fmt
      bitwarden
      bitwarden-cli
      okular
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

  home.stateVersion = "23.05";
}
