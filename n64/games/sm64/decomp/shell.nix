# NOTE: NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1

let
  pkgs = import <nixpkgs> {};
  crossPkgs = import <nixpkgs> {
    crossSystem = {
      config = "mips-linux-gnu";
    };
  };
in with pkgs;
crossPkgs.mkShell {
  buildInputs = [
    capstone
    libpng
    crossPkgs.gcc
  ];
  nativeBuildInputs = [
    pkg-config
    hexdump
    git
    gcc
    python3
  ];
}
