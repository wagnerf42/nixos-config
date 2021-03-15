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
    ref = "refs/heads/release-20.09";
    rev = "abaebf3b346c4bef500c5bd2fdebbed109261a0c";
  };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./grou-hardware-configuration.nix
      ../modules/common.nix
      ../modules/work.nix
      <musnix>
      (import "${home-manager}/nixos")
      ../modules/home.nix
    ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brgenml1cupswrapper
     pkgs.epson-escpr
  ];

    musnix.enable = true;
    musnix.kernel.optimize = true;
    musnix.kernel.realtime = true;
    # musnix.das_watchdog.enable = true;

# services.jack = {
#     jackd.enable = true;
#     # support ALSA only programs via ALSA JACK PCM plugin
#     alsa.enable = false;
#     # support ALSA only programs via loopback device (supports programs like Steam)
#     loopback = {
#       enable = true;
#       # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
#       #dmixConfig = ''
#       #  period_size 2048
#       #'';
#     };
#   };
  networking.firewall.allowedUDPPorts = [ 22124 27950 44400 ]; # jamulus + warsow

  environments.wagner.common.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.videoDrivers = ["intel"];
  programs.sway.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.layout = "us";
  hardware.opengl.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.packages = [ pkgs.networkmanagerapplet ];
  networking.hostName = "grou"; # Define your hostname.

# see : https://github.com/NixOS/nixpkgs/issues/88596
# Not strictly required but pipewire will use rtkit if it is present
# security.rtkit.enable = true;
# services.pipewire = {
#   enable = true;
#   # Compatibility shims, adjust according to your needs
#   # alsa.enable = true;
#   # alsa.support32Bit = true;
#   pulse.enable = true;
#   jack.enable = true;
# };

  environment.systemPackages = with pkgs; [
    jamulus
    (pkgs.callPackage ../config/warsow {})
  ];

}
