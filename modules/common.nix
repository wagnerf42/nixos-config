{ config, lib, pkgs, ... }:
with lib;

{
  options.environments.wagner.common = {
    enable = mkEnableOption "common";
  };

  config = mkIf config.environments.wagner.common.enable {
      nixpkgs.config.allowUnfree = true;
      services.xserver.windowManager.i3.enable = true;
      services.xserver.windowManager.i3.package = pkgs.i3-gaps;

      # Select internationalisation properties.
      i18n = {
         defaultLocale = "fr_FR.UTF-8";
      };

      console.font = "Lat1-Terminus16";
      console.keyMap = "us";

      # Set your time zone.
      time.timeZone = "Europe/Paris";

      # Enable the OpenSSH daemon.
      services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      networking.firewall.allowedUDPPorts = [ 43517 ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # Enable sound.
      sound.enable = true;
      hardware.pulseaudio.enable = true;

      # Enable the X11 windowing system.
      services.xserver.enable = true;
      services.xserver.xkbOptions = "eurosign:e";

      # Enable touchpad support.
      services.xserver.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.extraUsers.wagnerf = {
         isNormalUser = true;
         uid = 1000;
         extraGroups = ["wheel" "networkmanager" "docker" "jackaudio" "audio" "sway" "dialout" "scanner" "lp" ];
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
      system.stateVersion = "22.05"; # Did you read the comment?
  };
}
