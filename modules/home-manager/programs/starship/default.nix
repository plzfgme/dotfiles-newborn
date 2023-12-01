{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.programs.starship;
in
{
  options.newborn.homeManagerModules.programs.starship = {
    enable = mkEnableOption "starship with setup configuration";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
  };
}

