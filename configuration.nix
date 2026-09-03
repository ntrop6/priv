# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hakuspace-config.nix
    ];
  
  i18n.inputMethod = {
  enable = true;
  type = "fcitx5";
  fcitx5 = {
    waylandFrontend = true;               # proper Wayland input (fixes the diagnostic too)
    addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
  };
};

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.dhcpcd.enable = false;
  networking.resolvconf.enable = false;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];              # all keyboards
      settings.main = {
        # tap = Super+Space (launcher); hold = normal Super for all shortcuts
        leftmeta = "overload(meta, M-space)";
      };
    };
  };
  # Required by end-4 / end4-pC for location-aware widgets.
  services.geoclue2.enable = true;

  # Enable networking
  networking.networkmanager = {
    enable = true;
    dns = "none";
  };
  environment.etc."resolv.conf" = {
  mode = "0644";
  text = ''
    nameserver 192.168.1.20
    options edns0
  '';
};
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.opentabletdriver.enable = true;
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.graphics.enable = true;
  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "uk_UA.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "tr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "trq";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."otoka" = {
    isNormalUser = true;
    description = "otoka";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "bluetooth" ];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kdePackages.kdeconnect-kde
    osu-lazer
    gamescope
    zapret2
    avbroot
    unzip
    google-cloud-sdk
    mangohud
    tor-browser
    universal-android-debloater
    android-tools
    ffmpeg
    kdePackages.kdenlive
    pkgs.qbittorrent
    nicotine-plus
    tauon
    hyprshot
    hyprpolkitagent
    brightnessctl
    playerctl
    pkgs.osu-lazer
    krita
    easyeffects
    anki
    lutris
    opentabletdriver
    protonup-rs
    librewolf
    xwayland-satellite
    pkgs.protonup-qt
    inputs.niri-float-sticky.packages.${pkgs.system}.default
    bibata-cursors
    zapret2
    riseup-vpn  
    thunderbird
    git
    fastfetch
    discord
    nautilus
    keepassxc
    ghostty
  #  noctalia-shell
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.gamemode.enable = true;
  programs.obs-studio = {
  enable = true;
  enableVirtualCamera = true;   # webcam-out via v4l2loopback
  plugins = with pkgs.obs-studio-plugins; [
    wlrobs                       # wlroots screen capture fallback
    obs-pipewire-audio-capture   # per-app audio capture
    obs-vkcapture                # game capture (Vulkan/OpenGL)
  ];
}; 
  
  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };
  programs.niri.enable = true;
  programs.thunar.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.firefox.enable = true;
  programs.xfconf.enable = true;
  programs.steam = {
  enable = true;

  extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
};
  services.resolved.enable = false;

  xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
};

  services.flatpak.enable = true;
  services.displayManager.ly.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # PI HOLE
    services.pihole-ftl = {
    enable = true;
    settings = {
      dns.upstreams = [
        "9.9.9.9"      # Quad9
        "1.1.1.1"      # Cloudflare
      ];
      # Optional LAN names
      # dns.hosts = [ "192.168.1.10 nixos.lan" ];
    };

    lists = [
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/hosts/pro.txt";
        type = "block";
        enabled = true;
        description = "HaGeZi Multi PRO";
      }
    ];
  };

  services.pihole-web = {
    enable = true;
    ports = [ "80" ];   # or "443s" for HTTPS
  };

  
  fileSystems."/mnt/sda" = {
    device = "/dev/disk/by-uuid/2b5bcf9e-0cf5-4c57-90f0-072a30034f66"; # sda1
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.device-timeout=10s" ];
  };

  fileSystems."/mnt/sdb" = {
    device = "/dev/disk/by-uuid/8d0b2b24-bf5b-4988-bb3c-27e3485281d4"; # sdb1
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.device-timeout=10s" ];
  };

  # Open ports in the firewall.
    networking.firewall = {
    allowedTCPPorts = [ 53 80 443 ];
    allowedUDPPorts = [ 53 ];
  };
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
