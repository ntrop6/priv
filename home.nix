{ inputs, pkgs, lib, config, ... }:

{
  home.username = "otoka";
  home.homeDirectory = "/home/otoka";
  home.stateVersion = "26.05";

  imports = [
    inputs.nixcord.homeModules.nixcord
    inputs.zen-browser.homeModules.twilight
    inputs.illogical-flake.homeManagerModules.default
  ];

  programs.illogical-impulse = {
    enable = true;

    # Keep your existing shell/terminal setup instead of replacing it with
    # upstream Fish, Kitty, and Starship configurations.
    dotfiles = {
      fish.enable = false;
      kitty.enable = false;
      starship.enable = false;
    };
  };

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
        mods = [ "Nebula" ];
      };
    };
  };

  # illogical-flake first installs the end-4 base. This activation step then
  # adds end4-pC and restores the personal Hyprland overrides from this flake.
  home.activation.installEnd4PcAndPersonalConfig =
    lib.hm.dag.entryAfter [ "copyIllogicalImpulseConfigs" ] ''
      shellDir="$HOME/.config/quickshell/end4-pC"
      customDir="$HOME/.config/hypr/custom"

      $DRY_RUN_CMD rm -rf "$shellDir"
      $DRY_RUN_CMD mkdir -p "$HOME/.config/quickshell" "$customDir"
      $DRY_RUN_CMD cp -r ${inputs.end4-pc} "$shellDir"
      $DRY_RUN_CMD chmod -R u+w "$shellDir"

      # These are copied rather than linked because end-4 expects writable
      # configuration directories.
      $DRY_RUN_CMD cp -f ${./hypr-custom}/env.lua "$customDir/env.lua"
      $DRY_RUN_CMD cp -f ${./hypr-custom}/variables.lua "$customDir/variables.lua"
      $DRY_RUN_CMD cp -f ${./hypr-custom}/execs.lua "$customDir/execs.lua"
      $DRY_RUN_CMD cp -f ${./hypr-custom}/general.lua "$customDir/general.lua"
      $DRY_RUN_CMD cp -f ${./hypr-custom}/rules.lua "$customDir/rules.lua"
      $DRY_RUN_CMD cp -f ${./hypr-custom}/keybinds.lua "$customDir/keybinds.lua"
      $DRY_RUN_CMD chmod u+w "$customDir"/*.lua

      # Seed pC's mutable settings only on the first install. pC remains free
      # to save later changes made through its settings panel.
      shellState="$HOME/.config/illogical-impulse"
      $DRY_RUN_CMD mkdir -p "$shellState"
      if [ ! -e "$shellState/config.json" ]; then
        $DRY_RUN_CMD cp ${./end4-pc-initial-config.json} "$shellState/config.json"
        $DRY_RUN_CMD chmod u+w "$shellState/config.json"
      fi
    '';
}
