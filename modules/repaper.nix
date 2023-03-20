{ stdenv
, fetchurl
, zlib
, udev
, qt5
, bzip2
, glib
, lib
, libGL
, libpulseaudio
, unzip
, xorg
}:

stdenv.mkDerivation rec {
  name = "repaper";
  version = "11.1";
  src = ../RepaperStudio_11.1-amd64.zip;
  nativeBuildInputs = [ unzip qt5.wrapQtAppsHook ];
  buildInputs = [
    bzip2
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qtsvg
    qt5.qtconnectivity
    qt5.qtserialport
    qt5.qtquickcontrols2
    qt5.qtdeclarative
    libpulseaudio
    udev
    zlib
    glib
    libGL
    xorg.libXtst
    xorg.libX11
  ];

  preFixup = let
         # we prepare our library path in the let clause to avoid it become part of the input of mkDerivation
         libPath = lib.makeLibraryPath [
           bzip2
           qt5.qtbase
           qt5.qtmultimedia
           qt5.qtsvg
           qt5.qtconnectivity
           qt5.qtserialport
           qt5.qtquickcontrols2
           qt5.qtdeclarative
           libpulseaudio
           udev
           zlib
           stdenv.cc.cc.lib
           glib
           libGL
           xorg.libXtst
           xorg.libX11
         ];
         in ''
            patchelf \
              --replace-needed libbz2.so.1.0 libbz2.so.1 $out/bin/RepaperStudio
            patchelf \
              --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
              --set-rpath "${libPath}" \
              $out/bin/RepaperStudio
         '';

  installPhase = ''
    install -m755 -D RepaperStudio_11.1/RepaperStudio $out/bin/RepaperStudio
  '';

  meta = with lib; {
    homepage = https://www.iskn.co/fr;
    description = "Drawing application for the slate tablet by iskn";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
