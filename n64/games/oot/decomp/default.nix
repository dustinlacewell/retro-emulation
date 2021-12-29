{ pkgs ? import <nixpkgs> { } }:



let
  crossPkgs = import <nixpkgs> {
    crossSystem = {
      config = "mips-linux-gnu";
    };
  };
  toolchain = crossPkgs.stdenv.mkDerivation {
    name = "oot-decomp-toolchain";

    src = ./oot;

    buildInputs = [
      crossPkgs.gcc
      pkgs.libpng
    ];

    nativeBuildInputs = [
      pkgs.which
      pkgs.git
      pkgs.gcc
      pkgs.python3
    ];

    buildPhase = ''
      cp ${./patch.sh} ./patch.sh
      cp ${./baserom_original.n64} .
      bash ./patch.sh
      make setup
    '';
  };
in toolchain
