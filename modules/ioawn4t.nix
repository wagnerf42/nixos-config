{ stdenv, fetchurl, patchelf, xorg, allegro, libvorbis, libogg, libtheora, makeDesktopItem }:

let

  inherit (xorg) libXext libX11;

  lpath = "${stdenv.cc.cc.lib}/lib64:" + stdenv.lib.makeLibraryPath [
    allegro libvorbis libX11 libogg libtheora
  ];
  desktopItem = makeDesktopItem {
    name = "ioawn4t";
    exec = "ioawn4t";
    comment = "if on a winter's night four travellers";
    desktopName = "ioawn4t";
    categories = "Game;";
  };
in
stdenv.mkDerivation rec {
  name = "ioawn4t";
  src = /home/wagnerf/Downloads/ioawn4t.tar.gz;
  buildCommand = ''
    . $stdenv/setup

    unpackPhase

    mkdir -pv $out
    mkdir -pv $out/bin
    mkdir -pv $out/data
    cp -t $out/data data/ags64
    cp -t $out/data data/acsetup.cfg
    cp -t $out/data data/audio.vox
    cp -t $out/data data/ioawn4t.ags

    ${patchelf}/bin/patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/lib:${lpath}" \
      $out/data/ags64

    cat >$out/bin/ioawn4t <<EOF
    #!/bin/sh
    $out/data/ags64 \$@ $out/data/
    EOF
    chmod +x $out/bin/ioawn4t
  '';

  desktopItems = [ desktopItem ];

  meta = with stdenv.lib; {
    description = "Narrative-driven point-and-click adventure";
    homepage = "https://laurahunt.itch.io/if-on-a-winters-night-four-travelers";
    license = licenses.unfreeRedistributable;
    maintainers = [];

    platforms = ["x86_64-linux"];
  };
}
