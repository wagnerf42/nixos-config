{ stdenv
, mkDerivation
, fetchurl
, zlib
, systemd
, qt5
, bzip2
, glib
, lib
, libGL
, libpulseaudio
, wrapQtAppsHook
}:

mkDerivation rec {
  name = "imagink";

  src = fetchurl {
    url = "https://share.iskn.co/owncloud/public.php?service=files&t=b5332439a9db95192389ae399539093c&download";
    sha256 = "01c1lg26kl8708z0p16jg1cf9mwr0zldflvbw08rq0w1vqfr8r65";
    name = "Imagink_8.0-amd64.tar.gz";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];
  buildInputs = [
    bzip2
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qtsvg
    qt5.qtconnectivity
    qt5.qtserialport
    libpulseaudio
    systemd.lib
    zlib
    glib
    libGL
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
           libpulseaudio
           systemd.lib
           zlib
           stdenv.cc.cc.lib
           glib
           libGL
         ];
         in ''
            patchelf \
              --replace-needed libbz2.so.1.0 libbz2.so.1 $out/bin/Imagink
            patchelf \
              --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
              --set-rpath "${libPath}" \
              $out/bin/Imagink

            patchelf \
              --replace-needed libbz2.so.1.0 libbz2.so.1 $out/bin/Imagink_IPC_Broker
            patchelf \
              --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
              --set-rpath "${libPath}" \
              $out/bin/Imagink_IPC_Broker

            patchelf \
              --replace-needed libbz2.so.1.0 libbz2.so.1 $out/bin/Imagink_IPC_Report
            patchelf \
              --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
              --set-rpath "${libPath}" \
              $out/bin/Imagink_IPC_Report
         '';

  installPhase = ''
    install -m755 -D Imagink $out/bin/Imagink
    install -m755 -D Imagink_IPC_Broker $out/bin/Imagink_IPC_Broker
    install -m755 -D Imagink_IPC_Report  $out/bin/Imagink_IPC_Report
  '';

  meta = with stdenv.lib; {
    homepage = https://developer.iskn.co/discuss/59ec5e3f4b12050010126ffb;
    description = "Drawing application for the slate tablet by iskn";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
