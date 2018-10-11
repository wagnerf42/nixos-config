# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hopi-hardware-configuration.nix
    ];
  nixpkgs.config.allowUnfree = true;

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

  # Select internationalisation properties.
  i18n = {
     consoleFont = "Lat1-Terminus16";
     consoleKeyMap = "us";
     defaultLocale = "fr_FR.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget vim_configurable
     firefox evince enlightenment.terminology texlive.combined.scheme-full mplayer alacritty
     zsh zsh-prezto nix-zsh-completions zsh-completions
     gcc binutils rustup rustracer carnix rustc cargo cargo-asm rustup
     git
     thunderbird
     unzip
     direnv
     python3
     python36Packages.python-language-server
     gdb
  ];

  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  environment.etc = let
  # stolen from https://github.com/nickjanus/nixos-config/
  zsh_config = import ../modules/zsh.nix {
    inherit (pkgs) writeText zsh-prezto;
  };
  in zsh_config.environment_etc;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.browsing = true;
  services.printing.browsedConf = "BrowsePoll print.imag.fr:631";
  # Needed for printer discovery
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.windowManager.i3.enable = true;
  services.xserver.videoDrivers = ["nvidiaLegacy340"];

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.wagnerf = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = ["wheel"];
     shell = pkgs.zsh;
   };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

  fileSystems."/mnt/old" = {
    device = "/dev/sdb1";
    fsType = "ext4";
  };

}

