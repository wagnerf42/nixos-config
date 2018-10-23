{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

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
     firefox evince enlightenment.terminology texlive.combined.scheme-full mplayer alacritty vlc
     zsh zsh-prezto nix-zsh-completions zsh-completions
     gcc binutils rustup rustracer carnix rustc cargo cargo-asm rustup
     git
     thunderbird
     unzip
     direnv
     python3
     python36Packages.python-language-server
     gdb
     bc wxmaxima
     inkscape gimp-with-plugins
     gnuplot
     sshfs
     firejail
     slic3r-prusa3d meshlab openscad
     links
     feh
     nodejs
     wesnoth scummvm opendungeons
     webtorrent_desktop
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

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.windowManager.i3.enable = true;
  services.xserver.videoDrivers = ["nvidiaLegacy340"];

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

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
  system.stateVersion = "18.09"; # Did you read the comment?
}
