{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "impro-visor";
  version = "unstable-2019-06-19";

  src = fetchFromGitHub {
    owner = "Impro-Visor";
    repo = "Impro-Visor";
    rev = "550bbb554962249aceb0e82a72142e3e5b3c0d4a";
    hash = "sha256-cZEEv/fB0IkJEtSsUaR9RUj4s/GM6fhl4r92Fapdbk0=";
  };

  meta = with lib; {
    description = "The Impro-Visor program source";
    homepage = "https://github.com/Impro-Visor/Impro-Visor";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
  };
}
