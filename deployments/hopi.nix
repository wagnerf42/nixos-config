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
  imports = [ # Include the results of the hardware scan.
    ./hopi-hardware-configuration.nix
    ../modules/common.nix
    (import "${home-manager}/nixos")
    ../modules/home.nix
  ];

  environments.wagner.common.enable = true;
  services.xserver.videoDrivers = [ "nvidiaLegacy340" ];

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
  services.printing.browsing = true;
  services.printing.browsedConf = ''
    BrowsePoll print.imag.fr:631
      CreateIPPPrinterQueues All
      '';
  services.printing.logLevel = "debug";
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

