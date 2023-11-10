{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [ ];

  # System
  system.stateVersion = "23.05";

  # Bootloader
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
  };

  # Localization
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # Nix
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Networking
  networking = {
    hostName = "newborn";
    networkmanager.enable = true;
  };

  # Desktop
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";

    displayManager.sddm = {
      enable = true;
    };
  };
  programs.hyprland.enable = true;
  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      corefonts
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig = {
      sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "Noto Sans CJK TC" "Noto Sans CJK JP" "Noto Sans CJK KR" "Noto Color Emoji" ];
      serif = [ "Noto Serif" "Noto Serif CJK SC" "Noto Serif CJK TC" "Noto Serif CJK JP" "Noto Serif CJK KR" "Noto Color Emoji" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  environment.systemPackages = with pkgs; [
    home-manager
    inputs.agenix.packages.x86_64-linux.default # TODO: Add to pkgs.
    kitty
    rofi
    git
    curl
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };
  programs.ssh.enableAskPassword = false;

  users.users = {
    plzfgme = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      ];
      extraGroups = [ "networkmanager" "wheel" "video" ];
      shell = pkgs.nushell;
    };
  };
}
