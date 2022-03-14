{ lib, stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "arcwelder";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "FormerLurker";
    repo = "ArcWelderLib";
    rev = "${version}";
    sha256 = "0hs2xnki8294drks81md1mvq8kga9b5acidjmqwl4c87ma33jz8m";
  };

  nativeBuildInputs = [ cmake python3 ];

  installPhase = ''
    mkdir -p $out/bin
    cp ArcWelderConsole/ArcWelder $out/bin
  '';

  meta = with lib; {
    description = "post-process gcode paths for better 3d printing quality";
    homepage = "https://github.com/FormerLurker/ArcWelderLib";
    maintainers = [ ];
    license = [ licenses.agpl3Plus ];
    platforms = platforms.unix;
  };
}
