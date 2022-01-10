{ pkgs ? import <nixpkgs> { } }:

let
  crossPkgs = import <nixpkgs> {
    crossSystem = {
      config = "mips-linux-gnu";
    };
  };
in crossPkgs.stdenv.mkDerivation {
    name = "oot-decomp";

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

    dontInstall = true;

    patches = [
      ./zapd.patch
    ];

    buildPhase = ''
      cp ${./baserom_original.n64} ./baserom_original.n64

      interp=$(patchelf --print-interpreter $(which env))
      for version in 5.3 7.1; do
          for tool in cc cfe uopt ugen as1; do
              patchelf --set-interpreter $interp ./tools/ido_recomp/linux/$version/$tool
          done
      done

      make setup
      make -j8

      cp zelda_ocarina_mq_dbg.z64 $out
    '';


  }
