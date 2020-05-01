# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let home-manager = builtins.fetchGit {
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
      ./micro-hardware-configuration.nix
      ../modules/common.nix
      (import "${home-manager}/nixos")
    ];
  
  home-manager.users.wagnerf = { pkgs, ... }: {
      home.packages = [ pkgs.exa ];
  };

  environments.wagner.common.enable = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sdc"; # or "nodev" for efi only

  networking.hostName = "micro"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     minetest
     minecraft
     steam
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

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
  # services.xserver.videoDrivers = ["nvidiaLegacy340"]; # it's still dead :-(

  # Make Steam work
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };
  users.users.kinda = {
     isNormalUser = true;
     uid = 1001;
  };

  users.users.yann = {
     isNormalUser = true;
     uid = 1002;
  };

  users.users.remi = {
     isNormalUser = true;
     uid = 1004;
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

