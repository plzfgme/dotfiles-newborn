rec {
  desktop = {
    sway = ./desktop/sway;
    waybar = ./desktop/waybar;
    eww-bar = ./desktop/eww-bar;
  };

  programs = {
    nushell = ./programs/nushell;
    foot = ./programs/foot;
    alacritty = ./programs/alacritty;
    starship = ./programs/starship;
    bat = ./programs/bat;
  };

  allModules = [
    desktop.sway
    desktop.waybar
    desktop.eww-bar
    programs.nushell
    programs.foot
    programs.alacritty
    programs.starship
    programs.bat
  ];
}
