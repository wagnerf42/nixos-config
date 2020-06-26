{

  home-manager.users.wagnerf = { pkgs, ... }: {

    nixpkgs.config.packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
    };
    home.packages = [ pkgs.dconf ];
    home.keyboard.layout = "us";
    xsession.enable = true;
    xsession.windowManager.i3 = {
      enable = true;
      config = let mod = "Mod4"; in {
        fonts = [ "Noto Sans 14" ];
        modifier = mod;
        keybindings = pkgs.lib.mkOptionDefault {
          "${mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          # Pulse Audio controls
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5% #increase sound volume";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5% #decrease sound volume";
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle # mute sound";
          "${mod}+h" = "focus left";
          "${mod}+l" = "focus right";
          "${mod}+k" = "focus up";
          "${mod}+j" = "focus down";
        };
      };
    };
    programs.browserpass.enable = true; # we need this AND the ff plugin
    programs.password-store.enable = true; # we need this guy and to create the password repo in ~/.local/share/password-store
    services.password-store-sync.enable = true;
    programs.firefox = {
      enable = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        browserpass
        https-everywhere
        dark-night-mode
        text-contrast-for-dark-themes
        textern
        i-dont-care-about-cookies
        peertubeify
        ublock-origin
        vimium
      ];
      profiles = {wagnerf={name="wagnerf";};};
    };
    programs.alacritty = {
      enable = true;
      settings = {
        font.normal.family = "mononoki";
        font.normal.style = "Regular";
        font.size = 14;
      };
    };
    programs.git = {
      enable = true;
      userName = "frederic wagner";
      userEmail = "frederic.wagner@imag.fr";
    };
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      envExtra = ''
        export EDITOR=vim
        export PATH=$PATH:~/.cargo/bin
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
      '';
      loginExtra = ''
        setopt extendedglob
        source $HOME/.aliases
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
      brightness.day = "1";
      brightness.night = "0.6";
      tray = true;
    };
  };

}
