{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
    outputs.nixosModules.allModules
  ];

  newborn.nixosModules = {
    secrets.enable = true;
  };

  # System
  system.stateVersion = "24.11";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  wsl = {
    enable = true;
    defaultUser = "plzfgme";
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
    overlays = [
      inputs.eww.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Networking
  networking = {
    hostName = "dragon-wsl";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      # trustedInterfaces = [ "docker0" "virbr0" ];
    };
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      liberation_ttf
      source-han-sans
      source-han-serif
      source-han-mono
      corefonts
      font-awesome
      iosevka
      fira-mono
      fira-code
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraMono" "FiraCode" "Iosevka" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "Noto Sans CJK TC" "Noto Sans CJK JP" "Noto Sans CJK KR" "Noto Color Emoji" ];
        serif = [ "Noto Serif" "Noto Serif CJK SC" "Noto Serif CJK TC" "Noto Serif CJK JP" "Noto Serif CJK KR" "Noto Color Emoji" ];
        monospace = [ "FiraCode Nerd Font" "JetBrainsMono Nerd Font" "Noto Sans Mono CJK SC" "Noto Sans Mono CJK TC" "Noto Sans Mono CJK JP" "Noto Sans Mono CJK KR" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    home-manager
    inputs.agenix.packages.x86_64-linux.default # TODO: Add to pkgs.
    git
    curl
    neovim
    file
    config.boot.kernelPackages.cpupower
    config.boot.kernelPackages.perf
    gnome3.adwaita-icon-theme
    lsof
    sysstat
    man-pages
    man-pages-posix
    linux-manual
  ];

  services.sysstat = {
    enable = true;
  };
  services.locate = {
    enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };
  programs.ssh.enableAskPassword = false;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.zsh.enable = true;

  virtualisation.docker.enable = true;

  users.users = {
    plzfgme = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      shell = pkgs.zsh;
    };
  };
}
