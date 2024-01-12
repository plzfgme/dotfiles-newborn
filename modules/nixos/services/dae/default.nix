{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.nixosModules.services.dae;
in
{
  options.newborn.nixosModules.services.dae = {
    enable = mkEnableOption "dae";
    package = mkOption {
      type = types.package;
      default = pkgs.dae;
    };
    configFile = mkOption {
      type = types.path;
      default = config.age.secrets."config.dae".path;
    };
  };

  config = mkIf cfg.enable {
    services.dae = {
      enable = true;
      package = cfg.package;
      disableTxChecksumIpGeneric = false;
      configFile = "/etc/dae/config.dae";
      assets = with pkgs; [ v2ray-geoip v2ray-domain-list-community ];
      openFirewall = {
        enable = true;
        port = 12345;
      };
    };
    environment.etc."dae/config.dae".source = lib.mkForce cfg.configFile;
  };
}
