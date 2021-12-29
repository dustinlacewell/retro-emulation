# NOTE: NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1

let
  pkgs = import <nixpkgs> {};
in
{
  pkgsNative ? import <nixpkgs> { }
  ,pkgsCross ? import <nixpkgs> {
    crossSystem = {
      config = "mips-linux-gnu";
    };
  }
}:

pkgsCross.mkShell {
  buildInputs = [
    pkgsCross.gcc
    pkgsNative.libpng
  ];
  nativeBuildInputs = [
    pkgsNative.git
    pkgsNative.gcc
    pkgsNative.python3
    pkgsNative.mupen64plus
  ];
}
