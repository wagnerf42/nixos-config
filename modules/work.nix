{ config, lib, pkgs, ... }:
with lib;

{
  config = {
      environment.systemPackages = with pkgs; [
        (pkgs.libsForQt5.callPackage ../modules/imagink.nix {})
        pyprof2calltree
        ccls
        manpages
        gnumeric
        rustup
        ddd
        valgrind kcachegrind graphviz linuxPackages.perf
        ffmpeg
        vokoscreen
        gd
        pandoc
        texlive.combined.scheme-full
        gcc binutils
        git
        unzip
        zip
        direnv
        python37
        gdb
        wxmaxima
        gnuplot
        cmake gnumake
        psmisc
        doxygen
      ];
  };
}
