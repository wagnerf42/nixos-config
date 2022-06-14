# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hopi-hardware-configuration.nix
    ../modules/common.nix
  ];

  nix.trustedUsers = [ "root" "wagnerf" ];
  environments.wagner.common.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  # services.xserver.videoDrivers = [ "nv" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_340;
  boot.kernelPackages = pkgs.linuxPackages_5_4;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sdb"; # or "nodev" for efi only
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  environment.variables.LD_LIBRARY_PATH =
    "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
  networking.hostName = "hopi"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.browsing = false;
  # Needed for printer discovery
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # enable docker daemon
  virtualisation.docker.enable = true;

  programs.sway.enable = true;

  fileSystems."/mnt/old" = {
    device = "/dev/sdb1";
    fsType = "ext4";
  };
}
