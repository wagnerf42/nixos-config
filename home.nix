# this file is an independant home manager config
# for use in debian
{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.packages = with pkgs; [
    util-linux
    rsync
    audacity sox
    cachix
    manpages posix_man_pages
    (pkgs.callPackage ./config/my_vim.nix {})
    (pkgs.callPackage ./modules/adom.nix {})
    # rustc cargo
    rust-analyzer
    spotify
    neovim
    neovide
    chromium
    dconf
    direnv
    exa
    gnome3.gnome-backgrounds
    zsh
    nerdfonts
    noto-fonts-emoji
    wget
    links
    curl
    sshfs
    libreoffice
    evince
    python37Packages.youtube-dl
    pavucontrol
    imagemagick
    feh
    geeqie
    mplayer
    vlc
    inkscape
    gimp
    prusa-slicer
    meshlab
    openscad
    nixfmt
    file
    htop
    nix-prefetch-git
    xorg.xhost
    gnupg
    pciutils
    mc
    glxinfo
    enlightenment.terminology
    alacritty
    bc
    lxqt.qterminal
    # work
    strace
    pyprof2calltree
    ccls
    manpages
    gnumeric
    ddd
    valgrind
    kcachegrind
    graphviz
    linuxPackages.perf
    ffmpeg
    vokoscreen
    gd
    pandoc
    texlive.combined.scheme-full
    git
    unzip
    zip
    direnv
    python37
    gdb
    wxmaxima
    gnuplot
    cmake
    gnumake
    psmisc
    doxygen
  ];
  home.username = "wagnerf";
  home.homeDirectory = "/home/wagnerf";

  fonts.fontconfig.enable = true;
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = let mod = "Mod4";
    in {
      fonts = {
        names = [ "Noto Sans 14" ];
        size = 12.0;
      };
      modifier = mod;
      gaps.inner = 5;
      gaps.outer = 5;
      keybindings = pkgs.lib.mkOptionDefault {
        "${mod}+Return" = "exec ${pkgs.lxqt.qterminal}/bin/qterminal";
        # Pulse Audio controls
        "XF86AudioRaiseVolume" =
          "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5% #increase sound volume";
        "XF86AudioLowerVolume" =
          "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5% #decrease sound volume";
        "XF86AudioMute" =
          "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle # mute sound";
        "${mod}+h" = "focus left";
        "${mod}+l" = "focus right";
        "${mod}+k" = "focus up";
        "${mod}+j" = "focus down";
      };
    };
  };
  services.udiskie.enable = true;
  services.random-background = {
    enable = true;
    imageDirectory = "${pkgs.gnome3.gnome-backgrounds}/share/backgrounds/gnome";
  };
  programs.browserpass.enable = true; # we need this AND the ff plugin
  programs.password-store.enable =
    true; # we need this guy and to create the password repo in ~/.local/share/password-store
  services.password-store-sync.enable = true;

  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      browserpass
      https-everywhere
      text-contrast-for-dark-themes
      textern
      i-dont-care-about-cookies
      peertubeify
      ublock-origin
      vimium
    ];
    profiles = {
      wagnerf = {
        name = "wagnerf";
        settings = {
          "browser.search.region" = "FR";
          "browser.search.isUS" = false;
          "distribution.searchplugins.defaultLocale" = "fr";
          "general.useragent.locale" = "fr";
          "intl.locale.requested" = "fr,en-US";
        };
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "mononoki";
      font.normal.style = "Regular";
      font.size = 14;
    };
  };
  programs.kitty = {
    enable = true;
    font.name = "mononoki";
    font.size = 14;
  };
  programs.git = {
    enable = true;
    userName = "frederic wagner";
    userEmail = "frederic.wagner@imag.fr";
  };
  home.sessionVariables = {
      EDITOR = "vim";
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    envExtra = ''
      export PATH=~/.nix-profile/bin:$PATH:~/.cargo/bin
      export NIX_PATH=~/.nix-defexpr/channels
    '';
    history.extended = true;
    defaultKeymap = "viins";
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "colored-man-pages" "colorize" "vi-mode" ];
      theme = "gnzh";
    };
    initExtra = ''
      eval "$(direnv hook zsh)"
      alias ls=exa
    '';
    loginExtra = ''
      setopt extendedglob
      bindkey '^R' history-incremental-pattern-search-backward
      bindkey '^F' history-incremental-pattern-search-forward
    '';
  };
  gtk = {
    enable = true;
    font = {
      name = "Noto Sans 14";
      package = pkgs.noto-fonts;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
    theme = {
      name = "Adapta-Nokto";
      package = pkgs.adapta-gtk-theme;
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  services.rsibreak.enable = true;
  services.gnome-keyring.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.enableSshSupport = true;
  services.network-manager-applet.enable = true;
  services.flameshot.enable = true;
  services.redshift = {
    enable = true;
    latitude = "45.1667";
    longitude = "5.7167";
    settings = {
      redshift.brightness-day = "1";
      redshift.brightness-night = "0.6";
    };
    tray = true;
  };

  # email
  programs.mbsync.enable = true;
  programs.astroid.enable = true;
  programs.neomutt = {
    enable = true;
    sort = "reverse-date";
  };
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };
  accounts.email = {
    accounts.imag = {
      neomutt.enable = true;
      astroid.enable = true;
      address = "frederic.wagner@univ-grenoble-alpes.fr";
      # gpg = {
      #   key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
      #   signByDefault = true;
      # };
      imap.host = "zimbra.univ-grenoble-alpes.fr";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = true;
      realName = "Frédéric Wagner";
      signature = {
        text = ''
          http://datamove.imag.fr/frederic.wagner
        '';
        showSignature = "append";
      };
      passwordCommand = "mail-password";
      smtp = {
        host = "smtps.univ-grenoble-alpes.fr";
      };
      userName = "wagnerf@univ-grenoble-alpes.fr";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
