{ inputs, pkgs, ... }:

{
  home.username = "otoka";
  home.homeDirectory = "/home/otoka";

  home.stateVersion = "26.05";

  imports = [
    inputs.nixcord.homeModules.nixcord
    inputs.zen-browser.homeModules.twilight
  ];

  programs.nixcord = {
    enable = true;

    discord.equicord.enable = true;
  };

  programs.zen-browser = {
    enable = true;

    profiles.default = {
      isDefault = true;

      sine = {
        enable = true;
        mods = [
          "Nebula"
        ];
      };
    };
  };
}
