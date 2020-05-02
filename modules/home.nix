{
  home-manager.users.wagnerf = { pkgs, ... }: {
    home.packages = [ pkgs.exa pkgs.dconf ];
    programs.git = {
      enable = true;
      userName = "frederic wagner";
      userEmail = "frederic.wagner@imag.fr";
    };
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      history.extended = true;
      defaultKeymap = "viins";
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "colored-man-pages" "colorize" "vi-mode" ];
        theme = "gnzh";
      };
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

    services.gnome-keyring.enable = true;
    services.gpg-agent.enable = true;
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
