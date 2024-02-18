{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.programs.zsh;
in
{
  options.newborn.homeManagerModules.programs.zsh = {
    enable = mkEnableOption "zsh with setup configuration";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = false;
      zplug = {
        enable = true;
        plugins = [
          {
            name = "plugins/git";
            tags = [ "from:oh-my-zsh" ];
          }
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
          { name = "zsh-users/zsh-completions"; }
          { name = "marlonrichert/zsh-autocomplete"; }
          # Disabled because of conflict with zsh-autocomplete
          # { name = "jeffreytse/zsh-vi-mode"; }
        ];
      };
      initExtra = ''
        bindkey -v # vi mode
        bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
        bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
      '';
    };
  };
}

