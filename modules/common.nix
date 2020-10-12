{ config, lib, pkgs, ... }:
with lib;

let cfg = config.environment.wagner.common;
in {
  options.environments.wagner.common = {
    enable = mkEnableOption "common";
  };

  config = mkIf config.environments.wagner.common.enable {
      nixpkgs.config.allowUnfree = true;

      # Select internationalisation properties.
      i18n = {
         defaultLocale = "fr_FR.UTF-8";
      };

      console.font = "Lat1-Terminus16";
      console.keyMap = "us";

      # Set your time zone.
      time.timeZone = "Europe/Paris";

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        (pkgs.libsForQt5.callPackage ../modules/imagink.nix {})
        (pkgs.callPackage ../modules/hex-a-hop.nix {})
        nixfmt
        discord
        file
        pyprof2calltree
        ccls
        manpages
        chromium
        gnumeric
        htop
        libreoffice
        pavucontrol
        python37Packages.youtube-dl
        rustup
        (pkgs.callPackage ../config/my_vim.nix {})
        ddd
        nix-prefetch-git
        imagemagick
        valgrind kcachegrind graphviz linuxPackages.perf
        ffmpeg
        vokoscreen
        weechat
        geeqie
        xorg.xhost
        gd
        pandoc
        pciutils
        mc glxinfo
        wget
        firefox evince enlightenment.terminology
        # texlive.combined.scheme-full
	mplayer alacritty vlc
        gcc binutils
        git
        thunderbird
        unzip
        zip
        direnv
        python37
        gdb
        bc wxmaxima
        inkscape gimp
        gnuplot
        sshfs
        prusa-slicer
        meshlab openscad
        links
        feh
        cmake gnumake
        psmisc
        doxygen curl
      ];

      nixpkgs.overlays = [ (import ../nix-nerd-fonts-overlay/default.nix) ];
      fonts.fonts = with pkgs; [
        nerd-fonts.firacode
        nerd-fonts.iosevka
	    nerd-fonts.mononoki
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      programs.zsh.enable = true;
      programs.firejail.enable = true;

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
      services.xserver.windowManager.i3.package = pkgs.i3-gaps;

      # Enable touchpad support.
      services.xserver.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.extraUsers.wagnerf = {
         isNormalUser = true;
         uid = 1000;
         extraGroups = ["wheel" "networkmanager" "docker" "audio" "sway" "dialout" "jackaudio" ];
         shell = pkgs.zsh;
       };

      users.extraUsers.demo = {
         isNormalUser = true;
         uid = 1003;
         extraGroups = ["wheel"];
         shell = pkgs.zsh;
       };

      # This value determines the NixOS release with which your system is to be
      # compatible, in order to avoid breaking some software such as database
      # servers. You should change this only after NixOS release notes say you
      # should.
      system.stateVersion = "20.03"; # Did you read the comment?
  };
}
