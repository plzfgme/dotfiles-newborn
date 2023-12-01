{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.programs.nushell;
in
{
  options.newborn.homeManagerModules.programs.nushell = {
    enable = mkEnableOption "nushell with setup configuration";
  };

  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
    };
  };
}
