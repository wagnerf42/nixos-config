{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, nodePackages
}:

rustPlatform.buildRustPackage rec {
  pname = "banglecomm";
  version = "unstable-2023-03-17";

  src = fetchFromGitHub {
    owner = "wagnerf42";
    repo = "banglecomm";
    rev = "b7873c9a28c96c2c95bfe230dbba5c3d86576e98";
    hash = "sha256-j3yM/Sn1KacQ6KAJCPjSQzAJRv+Seo/l75wu2HOHKN8=";
  };

  cargoHash = "sha256-0d7j4K8qTW/t93NVb5I8mU2lXWxwLWA8W3Sg3/hw/co=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    nodePackages.uglify-js
  ];

  meta = with lib; {
    description = "Banglejs sync and upload command line tool";
    homepage = "https://github.com/wagnerf42/banglecomm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
