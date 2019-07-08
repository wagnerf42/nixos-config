# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hopi-hardware-configuration.nix
      ../modules/common.nix
    ];

    environments.wagner.common.enable = true;
    services.xserver.videoDrivers = ["nvidiaLegacy340"];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sdb"; # or "nodev" for efi only

  networking.hostName = "hopi"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.browsing = true;
  services.printing.browsedConf = "BrowsePoll print.imag.fr:631";
  # Needed for printer discovery
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  fileSystems."/mnt/old" = {
    device = "/dev/sdb1";
    fsType = "ext4";
  };
}

