# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "home_manager";
    url = "https://github.com/rycee/home-manager.git";
    # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable`
    ref = "refs/heads/release-20.03";
    rev = "a378bccd609c159fa8d421233b9c5eae04f02042";
  };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./trantor-hardware-configuration.nix
      ../modules/common.nix
      <musnix>
      (import "${home-manager}/nixos")
      ../modules/home.nix
    ];


    services.xserver.videoDrivers = ["modesettings"];

    environment.systemPackages = with pkgs; [
     wesnoth scummvm opendungeons
     webtorrent_desktop
     transmission-gtk
     minetest
     mesa
     ];

#  services.jack = {
#    jackd.enable = true;
#    # support ALSA only programs via ALSA JACK PCM plugin
#    alsa.enable = false;
#    # support ALSA only programs via loopback device (supports programs like Steam)
#    loopback = {
#      enable = true;
#      # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
#      #dmixConfig = ''
#      #  period_size 2048
#      #'';
#    };
#  };
#
#  musnix.enable = true;
#  musnix.kernel.optimize = true;
#  musnix.kernel.realtime = true;
#  musnix.rtirq.enable = true;
#  musnix.das_watchdog.enable =true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "trantor"; # Define your hostname.
  networking.extraHosts = "192.168.0.14 ananas";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # custom modeline because monitor is lying on edid
  services.xserver.monitorSection =  ''
    HorizSync       28.0 - 33.0
    VertRefresh     43.0 - 72.0
    Option          "DPMS"
    Modeline        "Mode 0" 225.0 2560 2608 2640 2720 1440 1443 1448 1481 +hsync -vsync
  '';
  services.xserver.deviceSection = ''
    Option "ModeValidation" "AllowNonEdidModes"
'';
  services.xserver.extraDisplaySettings = ''
    Option     "metamodes" "Mode 0"
'';
  services.xserver.exportConfiguration = true;
  services.xserver.resolutions = [{x = 2560; y = 1440;} {x = 1920; y = 1080;}];
  services.xserver.layout = "fr";
  services.xserver.desktopManager.lxqt.enable = true;
  # services.xserver.desktopManager.kodi.enable = true;

  # Make Steam work
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brgenml1cupswrapper
     pkgs.epson-escpr
  ];
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ 
        (pkgs.callPackage ../modules/utsushi.nix {})
  ];
  services.udev.packages = [pkgs.utsushi ];

  services.avahi.enable = true;

  users.users.kinda = {
     extraGroups = [ "scanner" "lp" ];
     isNormalUser = true;
     uid = 1001;
  };

  users.users.yann = {
     isNormalUser = true;
     uid = 1002;
  };

}
