{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.collections.basic-cmd-tools;
in
{
  options.newborn.homeManagerModules.collections.basic-cmd-tools = {
    enable = mkEnableOption "Collections of basic command line tools";
  };

  config = mkIf cfg.enable {
    newborn.homeManagerModules.programs = {
      bat.enable = true;
    };

    programs.zoxide.enable = true;
    programs.eza = {
      enable = true;
      icons = true;
    };
    programs.ripgrep.enable = true;
    programs.fzf.enable = true;

    home.packages = with pkgs; [
      fd
    ];
  };
}

