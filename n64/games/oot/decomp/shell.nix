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
    libpng
    crossPkgs.gcc
  ];
  nativeBuildInputs = [
    git
    gcc
    python3
  ];
}
