{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.programs.foot;
in
{
  options.newborn.homeManagerModules.programs.foot = {
    enable = mkEnableOption "foot with setup configuration";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./foot.toml);
    };
  };
}
