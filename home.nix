# this file is an independant home manager config
# for use in debian
{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.packages = with pkgs; [
    # mutt
    msmtp
    neomutt
    mutt-wizard # you'll also need pass (note for me: use short login)
    isync
    # dev
    man-pages posix_man_pages
    (pkgs.callPackage ./config/my_vim.nix {})
    (pkgs.callPackage ./config/monaspace.nix {})
    # (pkgs.callPackage ./modules/repaper.nix {})
    (pkgs.callPackage ./config/banglecomm.nix {})
    # rustup
    cargo rustc rustfmt
    rust-analyzer
    strace
    pyprof2calltree
    ccls
    ddd
    valgrind
    kcachegrind
    graphviz
    linuxPackages.perf
    git
    gcc
    cmake
    gnumake
    psmisc
    doxygen
    gdb
    # unix
    wezterm
    util-linux
    rsync
    cachix
    dconf
    eza bat
    zsh
    wget
    links2
    curl
    sshfs
    nixfmt-classic
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
    unzip
    zip
    direnv
    # multimedia
    gnome.eog geeqie
    audacity sox
    # (pkgs.callPackage ./config/arcwelder.nix {})
    spotify
    gnome3.gnome-backgrounds
    evince
    python310Packages.youtube-dl
    pavucontrol
    imagemagick
    feh
    mplayer
    vlc
    inkscape
    gimp
    prusa-slicer
    meshlab
    openscad
    ffmpeg
    vokoscreen
    # office
    libreoffice
    gnumeric
    pandoc
    # math
    wxmaxima
    gnuplot
    # web
    vieb
    chromium
    thunderbird
    # heavy
    # nerdfonts
    noto-fonts-emoji
    texlive.combined.scheme-full
  ];
  home.username = "wagnerf";
  home.homeDirectory = "/home/wagnerf";

  fonts.fontconfig.enable = true;
  xsession.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    config = let mod = "Mod4"; in {
      modifier = mod;
      terminal = "${pkgs.lxqt.qterminal}/bin/qterminal";
    };
  };
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
        "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
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
  # services.password-store-sync.enable = true; #TODO: git-sync
  services.opensnitch-ui.enable = true;

  programs.helix= {
    enable = true;
    settings =
    {
      theme = "github_light_high_contrast";
    };
    languages = {
        rust = {
          config.checkOnSave = {command = "clippy";};
        };
        javascript = {
          # auto-format = true;
          formatter = { command = "prettier"; args = ["--parser" "typescript"]; };
        };
    };
  };
  programs.firefox = {
    enable = true;
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
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          browserpass
          textern
          i-dont-care-about-cookies
          ublock-origin
          vimium
        ];
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "Monaspace Argon";
      font.normal.style = "Regular";
      font.size = 16;
    };
  };
  programs.kitty = {
    enable = true;
    font.name = "Monaspace Argon";
    font.size = 16;
    settings = {enable_audio_bell = false;};
    theme = "GitHub Light Colorblind";
  };
  programs.git = {
    enable = true;
    userName = "frederic wagner";
    userEmail = "frederic.wagner@imag.fr";
  };
  home.sessionVariables = {
      EDITOR = "vim";
      CARGO_REGISTRIES_CRATES_IO_PROTOCOL="sparse";
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    envExtra = ''
      export PATH=~/.cargo/bin:~/.nix-profile/bin:$PATH
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
      alias ls=eza
      alias cat="bat --theme gruvbox-light"
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
      name = "HighContrast";
      package = pkgs.gnome-themes-extra;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  services.rsibreak.enable = true;
  services.gnome-keyring.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.enableSshSupport = true;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-gtk2;
  services.network-manager-applet.enable = true;
  services.flameshot.enable = true;
  # services.redshift = {
  #   enable = true;
  #   latitude = "45.1667";
  #   longitude = "5.7167";
  #   settings = {
  #     redshift.brightness-day = "0.9";
  #     redshift.brightness-night = "0.7";
  #   };
  #   tray = true;
  # };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
}
