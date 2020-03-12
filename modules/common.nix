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
         consoleFont = "Lat1-Terminus16";
         consoleKeyMap = "us";
         defaultLocale = "fr_FR.UTF-8";
      };

      # Set your time zone.
      time.timeZone = "Europe/Paris";

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        android-file-transfer
        docker
        nodejs yarn # these are dependencies for coc-nvim
        espeak
        udisks usermount
        openbox
        cpufrequtils
        discord
        file
        libvpx
        pyprof2calltree
        ccls
        manpages
        qemu
        # zoom-us
        chromium
        exercism
        gnumeric
        htop
        libreoffice
        pavucontrol
        pdf2svg
        redshift
        (pkgs.callPackage ../modules/oldhwloc.nix {})
        python37Packages.openpyxl
        python37Packages.setuptools
        python37Packages.pylint
        perlPackages.TextIconv
        libreoffice
        python37Packages.youtube-dl
        subversion
        ntp
        python37Packages.markdown
        python37Packages.pip
        nssmdns
        pkgconfig
        # my vim config
        rustup
        # rustc cargo rls rustracer rustfmt # needed for vim
        (pkgs.callPackage ../config/my_vim.nix {})
        python37Packages.pelican
        ddd
        nix-prefetch-git
        imagemagick
        valgrind kcachegrind graphviz linuxPackages.perf
        ffmpeg
        vokoscreen
        apg
        weechat
        geeqie
        xorg.xhost
        gd
        pandoc
        pciutils
        mc glxinfo
        wget vim_configurable
        firefox evince enlightenment.terminology texlive.combined.scheme-full mplayer alacritty vlc
        zsh zsh-prezto nix-zsh-completions zsh-completions
        gcc binutils
        git
        thunderbird
        unzip
        zip
        direnv
        python37
        python37Packages.python-language-server
        gdb
        bc wxmaxima
        inkscape gimp
        gnuplot
        sshfs
        firejail
        zoom
        # prusa-slicer
        meshlab openscad
        links
        feh
        cmake gnumake clang
        psmisc
        doxygen curl
      ];

      fonts.fonts = with pkgs; [
        nerdfonts
        iosevka
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
         extraGroups = ["wheel" "networkmanager" "docker" "audio" "sway" "dialout" ];
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
      system.stateVersion = "19.03"; # Did you read the comment?
  };
}
