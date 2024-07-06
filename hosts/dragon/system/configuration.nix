{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-cpu-amd-raphael-igpu
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-acpi_call
    inputs.hardware.nixosModules.common-pc-laptop-ssd

    inputs.agenix.nixosModules.default

    # inputs.daeuniverse.nixosModules.dae
    # inputs.daeuniverse.nixosModules.daed

    outputs.nixosModules.allModules

    ./hardware-configuration.nix
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    # powerManagement.enable = false;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:8:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  newborn.nixosModules = {
    secrets.enable = true;

    services.dae = {
      enable = true;
      # package =
      # let
      # pname = "dae";
      # version = "unstable-2023-11-15";
      # src = pkgs.fetchFromGitHub {
      # owner = "daeuniverse";
      # repo = pname;
      # rev = "25c047a766a8ae33e6acdecd9b5ab74b3d9baeb1";
      # hash = "sha256-iwqNVkjYNNd46Yu1vt427aW0srCkZoG8bTGKimP3AjM=";
      # fetchSubmodules = true;
      # };
      # vendorHash = "sha256-OD6Ztjw2O+2bf8DYDEptp9YfMpsma/Ag1/s5rKyCTmQ=";
      # postInstall = ''
      # install -Dm444 install/dae.service $out/lib/systemd/system/dae.service
      # substituteInPlace $out/lib/systemd/system/dae.service \
      #  --replace /usr/bin/dae $out/bin/dae
      # '';
      # in
      # (pkgs.dae.override {
      # buildGoModule = args: pkgs.buildGoModule (
      # args // {
      # inherit pname version src vendorHash postInstall;
      # }
      # );
      # });
    };
  };

  # System
  system.stateVersion = "24.05";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
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
      inputs.eww.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Networking
  networking = {
    hostName = "dragon";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "docker0" "virbr0" ];
    };
  };

  # Desktop
  services.xserver = {
    enable = true;

    xkb = {
      variant = "";
      layout = "us";
    };
    dpi = 96;

    displayManager.startx.enable = true;
    windowManager.i3 = {
      enable = true;
    };
  };
  programs.sway.enable = true;
  programs.sway.wrapperFeatures.gtk = true;
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'zsh --login -c \"WLR_DRM_DEVICES=/dev/dri/card1 sway --unsupported-gpu\"'";
      };
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
    file
    config.boot.kernelPackages.cpupower
    config.boot.kernelPackages.perf
    gnome3.adwaita-icon-theme
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
  hardware.brillo.enable = true;

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

  services.tlp = {
    enable = true;
    settings = {
      # Fix nvidia RTD3 issue.
      SOUND_POWER_SAVE_ON_AC = 1;
      SOUND_POWER_SAVE_ON_BAT = 1;
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
      RUNTIME_PM_DENYLIST = "01:00.0 01:00.1";

      CPU_DRIVER_OPMODE_ON_AC = "active";
      CPU_DRIVER_OPMODE_ON_BAT = "guided";
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "ondemand";
      CPU_SCALING_MIN_FREQ_ON_AC = 0;
      CPU_SCALING_MAX_FREQ_ON_AC = 9999999;
      CPU_SCALING_MIN_FREQ_ON_BAT = 0;
      CPU_SCALING_MAX_FREQ_ON_BAT = 4500000;
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
    };
  };
  virtualisation.docker.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = with pkgs; [
          OVMFFull.fd
        ];
      };
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  users.users = {
    plzfgme = {
      isNormalUser = true;
      extraGroups = [ "libvirtd" "networkmanager" "wheel" "docker" "video" ];
      shell = pkgs.zsh;
    };
  };
}
