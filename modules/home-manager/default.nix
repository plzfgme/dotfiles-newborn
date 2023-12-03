rec {
  desktop = {
    sway = ./desktop/sway;
    waybar = ./desktop/waybar;
    eww-bar = ./desktop/eww-bar;
    swww = ./desktop/swww;
  };

  programs = {
    nushell = ./programs/nushell;
    zsh = ./programs/zsh;
    foot = ./programs/foot;
    alacritty = ./programs/alacritty;
    starship = ./programs/starship;
    bat = ./programs/bat;
  };

  collections = {
    basic-cmd-tools = ./collections/basic-cmd-tools;
  };

  allModules = [
    desktop.sway
    desktop.waybar
    desktop.eww-bar
    desktop.swww

    programs.nushell
    programs.zsh
    programs.foot
    programs.alacritty
    programs.starship
    programs.bat

    collections.basic-cmd-tools
  ];
}
