{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
}:

rustPlatform.buildRustPackage rec {
  pname = "banglecomm";
  version = "unstable-2023-03-17";

  src = fetchFromGitHub {
    owner = "wagnerf42";
    repo = "banglecomm";
    rev = "1945733ab8be59bc3f62228679353d6d0d580762";
    hash = "sha256-hwADAn3nxZvshWXz6Ppai4kl/edUkuEqH4ot4ccSa10=";
  };

  cargoHash = "sha256-0d7j4K8qTW/t93NVb5I8mU2lXWxwLWA8W3Sg3/hw/co=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  meta = with lib; {
    description = "Banglejs sync and upload command line tool";
    homepage = "https://github.com/wagnerf42/banglecomm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
