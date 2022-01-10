{ pkgs ? import <nixpkgs> { } }:

let
  crossPkgs = import <nixpkgs> {
    crossSystem = {
      config = "mips-linux-gnu";
    };
  };
in crossPkgs.stdenv.mkDerivation {
    name = "sm64-decomp";

    src = pkgs.fetchFromGitHub {
      owner = "n64decomp";
      repo = "sm64";
      rev = "master";
      sha256 = "sha256-5d2aMGLPPZNTMELd013NKPhXhsXeo7bN+XKYvyj6QkE=";
    };

    buildInputs = [
      pkgs.capstone
      pkgs.libpng
      crossPkgs.gcc
    ];

    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.hexdump
      pkgs.git
      pkgs.gcc
      pkgs.which
      pkgs.python3
    ];

    dontInstall = true;

    buildPhase = ''
      cp ${./baserom.us.z64} ./baserom.us.z64
      make VERSION=us -j8
      cp -r build/us/sm64.us.z64 $out
    '';
  }
