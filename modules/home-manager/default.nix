rec {
  desktop = {
    sway = ./desktop/sway;
    waybar = ./desktop/waybar;
    eww-bar = ./desktop/eww-bar;
    swww = ./desktop/swww;
    i3 = ./desktop/i3;
  };

  programs = {
    nushell = ./programs/nushell;
    zsh = ./programs/zsh;
    foot = ./programs/foot;
    alacritty = ./programs/alacritty;
    starship = ./programs/starship;
    bat = ./programs/bat;
    neovim = ./programs/neovim;
    rofi = ./programs/rofi;
    kitty = ./programs/kitty;
  };

  collections = {
    basic-cmd-tools = ./collections/basic-cmd-tools;
  };

  services = {
    mako = ./services/mako;
  };

  allModules = {
    imports = [
      desktop.sway
      desktop.waybar
      desktop.eww-bar
      desktop.swww
      desktop.i3

      programs.nushell
      programs.zsh
      programs.foot
      programs.alacritty
      programs.starship
      programs.bat
      programs.neovim
      programs.rofi
      programs.kitty

      collections.basic-cmd-tools

      services.mako
    ];
  };
}
