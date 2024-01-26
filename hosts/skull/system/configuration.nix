{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-amd

    inputs.agenix.nixosModules.default

    inputs.daeuniverse.nixosModules.dae
    inputs.daeuniverse.nixosModules.daed

    outputs.nixosModules.allModules

    ./hardware-configuration.nix
  ];

  newborn.nixosModules = {
    secrets.enable = true;

    services.dae = {
      enable = true;
      package =
        let
          pname = "dae";
          version = "unstable-2023-11-15";
          src = pkgs.fetchFromGitHub {
            owner = "daeuniverse";
            repo = pname;
            rev = "25c047a766a8ae33e6acdecd9b5ab74b3d9baeb1";
            hash = "sha256-iwqNVkjYNNd46Yu1vt427aW0srCkZoG8bTGKimP3AjM=";
            fetchSubmodules = true;
          };
          vendorHash = "sha256-OD6Ztjw2O+2bf8DYDEptp9YfMpsma/Ag1/s5rKyCTmQ=";
          postInstall = ''
            install -Dm444 install/dae.service $out/lib/systemd/system/dae.service
            substituteInPlace $out/lib/systemd/system/dae.service \
              --replace /usr/bin/dae $out/bin/dae
          '';
        in
        (pkgs.dae.override {
          buildGoModule = args: pkgs.buildGoModule (
            args // {
              inherit pname version src vendorHash postInstall;
            }
          );
        });
    };
  };

  # System
  system.stateVersion = "23.11";

  # Bootloader
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
    };
    efi.canTouchEfiVariables = true;
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
      inputs.rust-overlay.overlays.default
      inputs.eww.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Networking
  networking = {
    hostName = "skull";
    networkmanager.enable = true;

  };

  # Desktop
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    dpi = 96;
  };
  programs.sway.enable = true;
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
    };
  };
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'zsh --login -c sway'";
      };
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      corefonts
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "Noto Sans CJK TC" "Noto Sans CJK JP" "Noto Sans CJK KR" "Noto Color Emoji" ];
        serif = [ "Noto Serif" "Noto Serif CJK SC" "Noto Serif CJK TC" "Noto Serif CJK JP" "Noto Serif CJK KR" "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK SC" "Noto Sans Mono CJK TC" "Noto Sans Mono CJK JP" "Noto Sans Mono CJK KR" "Noto Color Emoji" ];
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
    nushell
    vscode
    nil
    nixpkgs-fmt
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman = {
    enable = true;
  };

  services.udisks2.enable = true;

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

  services.thermald.enable = true;
  services.tlp.enable = true;

  virtualisation = {
    docker = {
      enable = true;
    };
  };

  users.users = {
    plzfgme = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      shell = pkgs.zsh;
    };
  };
}
