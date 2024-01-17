{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.newborn.homeManagerModules.programs.neovim;
  lazyVim = builtins.fetchGit {
    url = "https://github.com/LazyVim/starter.git";
    rev = "92b2689e6f11004e65376e84912e61b9e6c58827";
  };
  readFilesRec = path: base:
    builtins.concatLists
      (attrsets.mapAttrsToList
        (name: value: if value == "directory" then readFilesRec (path + "/" + name) (base + "/" + name) else [ (base + "/" + name) ])
        (builtins.readDir path));
  lazyVimFiles = builtins.listToAttrs
    (builtins.map
      (path: {
        name = "nvim" + path;
        value = {
          source = lazyVim + path;
        };
      })
      (readFilesRec lazyVim ""));
  basicLspsAndFormatters = with pkgs; [
    lua-language-server
    stylua
    shfmt
  ];
in
{
  options.newborn.homeManagerModules.programs.neovim = {
    enable = mkEnableOption "neovim with LazyVim";
    enableBasicLspAndFormatters = mkOption {
      type = types.bool;
      default = true;
      description = "enable basic language servers and formatters (lua-language-server, stylua, shfmt)";
    };
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "set neovim as default editor";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
    };
    xdg.configFile = lazyVimFiles // {
      "nvim/lua/plugins/disable-mason.lua".source = ./disable-mason.lua;
    };
    home.packages = with pkgs; [
      lazygit
      gcc
      gnumake
      ripgrep
      fd
    ] ++ (if cfg.enableBasicLspAndFormatters then basicLspsAndFormatters else [ ]);

    home.sessionVariables.EDITOR = mkIf cfg.defaultEditor "nvim";
  };
}

