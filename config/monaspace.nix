{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "monaspace";
  version = "1.000";

  src = fetchzip {
    url = "https://github.com/githubnext/monaspace/releases/download/v1.000/monaspace-v1.000.zip";
    sha256 = "0w7kwkx0bhrpvf7xjc8zbs877sfqs49jdvl71qyvd4jmx95lxhqz";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 monaspace-v1.000/fonts/otf/*.otf -t $out/share/fonts/opentype
    install -Dm644 monaspace-v1.000/fonts/variable/*.ttf -t $out/share/fonts/truetype
    mkdir -p $out/etc/fonts/conf.d
    cp -v ${./monaspace-scaling.conf} $out/etc/fonts/conf.d/30-monaspace-scaling.conf

    runHook postInstall
  '';

  meta = with lib; {

    homepage = "https://github.com/githubnext/monaspace";
    description = "Monospace font for Firefox OS";
    longDescription = ''
    The Monaspace type system: a monospaced type superfamily with some modern tricks up its sleeves.
    It is comprised of five variable axis typefaces. Each one has a distinct voice,
    but they are all metrics-compatible with one another,
    allowing you to mix and match them for a more expressive typographical palette.
    '';
    license = licenses.ofl;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
