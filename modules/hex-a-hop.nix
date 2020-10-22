{ stdenv, fetchurl, SDL_mixer
, SDL, SDL_ttf }:

stdenv.mkDerivation rec {
  pname = "hex-a-hop";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/hexahop/1.1.0/hex-a-hop-${version}.tar.gz";
    name = "${pname}-${version}.tar.gz";
    sha256 = "1mm069wpwc8nrrzfn2f64vh550634xlfws64bfmhqhx86vcikgw0";
  };

  nativeBuildInputs = [ ];
  buildInputs = [ SDL SDL_mixer SDL_ttf ];

  # cmakeFlags = [
  #   "-DEIGEN_INCLUDE_DIR=${eigen2}/include/eigen2"
  # ];

  meta = with stdenv.lib; {
    description = "A nice puzzle game";
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    license = licenses.free;
    downloadPage = https://sourceforge.net/projects/hexahop/files/;
  };
}
