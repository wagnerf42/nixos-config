# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./grou-hardware-configuration.nix
      ../modules/common.nix
    ];

    environments.wagner.common.enable = true;
    services.xserver.videoDrivers = ["intel"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.layout = "us";
  hardware.opengl.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.packages = [ pkgs.networkmanagerapplet ];
  networking.hostName = "grou"; # Define your hostname.

}
