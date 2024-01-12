{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.nixosModules.secrets;
in
{
  options.newborn.nixosModules.secrets = {
    enable = mkEnableOption "secrets";
  };

  config = mkIf cfg.enable {
    age.secrets."config.dae".file = ../../../secrets/config.dae;
  };
}
