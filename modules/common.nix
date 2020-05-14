{ config, lib, pkgs, ... }:
with lib;

let cfg = config.environment.wagner.common;
in {
  options.environments.wagner.common = {
    enable = mkEnableOption "common";
  };

  config = mkIf config.environments.wagner.common.enable {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.packageOverrides = super: let self = super.pkgs; in {
        linuxPackages = super.linuxPackages.extend (linuxSelf: linuxSuper:
        let
          generic = args: linuxSelf.callPackage (import <nixos/pkgs/os-specific/linux/nvidia-x11/generic.nix> args) { };
        in {
          nvidiaPackages = linuxSuper.nvidiaPackages // {
            legacy_340 = generic {
              version = "340.108";
              sha256_32bit = "1jkwa1phf0x4sgw8pvr9d6krmmr3wkgwyygrxhdazwyr2bbalci0";
              sha256_64bit = "06xp6c0sa7v1b82gf0pq0i5p0vdhmm3v964v0ypw36y0nzqx8wf6";
              settingsSha256 = "1zf0fy9jj6ipm5vk153swpixqm75iricmx7x49pmr97kzyczaxa7";
              persistencedSha256 = "0v225jkiqk9rma6whxs1a4fyr4haa75bvi52ss3vsyn62zzl24na";
              useGLVND = false;

              patches = [ <nixos/pkgs/os-specific/linux/nvidia-x11/vm_operations_struct-fault.patch> ];
            };
          };
        });
      };

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
        nixfmt
        android-file-transfer
        docker
        nodejs yarn # these are dependencies for coc-nvim
        espeak
        udisks usermount
        openbox
        cpufrequtils
        # discord
        file
        libvpx
        pyprof2calltree
        ccls
        manpages
        qemu
        zoom-us
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
        firefox evince enlightenment.terminology 
    texlive.combined.scheme-full
	mplayer alacritty vlc
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
        iosevka
	    mononoki
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.bash.enableCompletion = true;
      # programs.mtr.enable = true;
      # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
      programs.zsh.enable = true;
      programs.firejail.enable = true;
      # programs.firejail.wrappedBinaries = {
      #   zoom-us = "''${lib.getBin pkgs.zoom-us}/bin/zoom-us";
      # };

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
