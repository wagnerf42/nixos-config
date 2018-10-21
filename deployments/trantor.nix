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
  
  # services.xserver.monitorSection =  'Modeline        "Mode 0" 225.0 2560 2608 2640 2720 1440 1443 1448 1481 +hsync -vsync'
    

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
