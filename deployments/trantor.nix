# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./trantor-hardware-configuration.nix
      ../modules/common.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "trantor"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # custom modeline because monitor is lying on edid
  services.xserver.monitorSection =  ''
    HorizSync       28.0 - 33.0
    VertRefresh     43.0 - 72.0
    Option         "DPMS"
    Modeline        "Mode 0" 225.0 2560 2608 2640 2720 1440 1443 1448 1481 +hsync -vsync
  '';
  services.xserver.deviceSection = ''
    Option "ModeValidation" "AllowNonEdidModes"
'';
  services.xserver.exportConfiguration = true;
  services.xserver.resolutions = [{x = 2560; y = 1440;} {x = 1920; y = 1080;} {x = 1280; y = 1024;} {x = 1024; y = 768;} {x = 800; y = 600;} {x = 640; y = 480;}];
  services.xserver.layout = "fr";
  services.xserver.desktopManager.lxqt.enable = true;


  # Enable CUPS to print documents.
  services.printing.enable = true;

  users.users.kinda = {
     isNormalUser = true;
     uid = 1001;
  };

  users.users.yann = {
     isNormalUser = true;
     uid = 1002;
  };

}