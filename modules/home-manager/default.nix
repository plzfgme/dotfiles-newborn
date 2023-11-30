rec {
  desktop = {
    sway = ./desktop/sway;
    waybar = ./desktop/waybar;
    eww-bar = ./desktop/eww-bar;
  };

  programs = {
    nushell = ./programs/nushell;
    foot = ./programs/foot;
  };

  allModules = [
    desktop.sway
    desktop.waybar
    desktop.eww-bar
    programs.nushell
    programs.foot
  ];
}
