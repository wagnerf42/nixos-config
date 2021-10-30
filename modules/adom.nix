{ stdenv, lib, fetchurl, patchelf, xorg, curl, SDL2, SDL2_image, SDL2_mixer, SDL2_net, SDL2_ttf, ncurses5, libGL, libGLU, zlib, luajit }:

let

  inherit (xorg) libXext libX11;

  lpath = "${stdenv.cc.cc.lib}/lib64:" + lib.makeLibraryPath [
    curl SDL2 SDL2_image SDL2_mixer SDL2_net SDL2_ttf ncurses5 libGL libGLU zlib luajit
  ];
in
stdenv.mkDerivation rec {
  name = "adom-${version}-noteye";
  version = "3.3.3";
  src = ../adom_noteye_linux_debian_64_3.3.3.tar.gz;
  buildCommand = ''
    . $stdenv/setup

    unpackPhase

    mkdir -pv $out
    cp -r -t $out adom/*

    rm $out/lib/libcurl.so.4
    rm $out/lib/libFLAC.so.8
    rm $out/lib/libjpeg.so.62
    rm $out/lib/libluajit-5.1.so.2
    rm $out/lib/libogg.so.0
    rm $out/lib/libSDL2-2.0.so.0
    rm $out/lib/libSDL2_image-2.0.so.0
    rm $out/lib/libSDL2_mixer-2.0.so.0
    rm $out/lib/libSDL2_net-2.0.so.0
    rm $out/lib/libSDL2_ttf-2.0.so.0
    rm $out/lib/libtiff.so.5
    rm $out/lib/libvorbisfile.so.3
    rm $out/lib/libvorbis.so.0
    rm $out/lib/libz.so

    chmod u+w $out/lib
    for l in $out/lib/*so* ; do
      chmod u+w $l
      ${patchelf}/bin/patchelf \
        --set-rpath "$out/lib:${lpath}" \
        $l
    done

    ${patchelf}/bin/patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/lib:${lpath}" \
      $out/adom

    mkdir $out/bin
    cat >$out/bin/adom <<EOF
    #! ${stdenv.shell}
    (cd $out; exec $out/adom ; )
    EOF
    chmod +x $out/bin/adom
  '';

  meta = with lib; {
    description = "A rogue-like game with nice graphical interface";
    homepage = "http://adom.de/";
    license = licenses.unfreeRedistributable;
    maintainers = [maintainers.smironov];

    # Please, notify me (smironov) if you need the x86 version
    platforms = ["x86_64-linux"];
  };
}
