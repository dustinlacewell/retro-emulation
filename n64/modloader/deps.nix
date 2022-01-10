{ pkgs ? import <nixpkgs> { } }:

let
  glew = pkgs.glew.overrideAttrs (old: rec {
    version = "2.1.0";
    src = pkgs.fetchurl {
      url = "mirror://sourceforge/glew/${pkgs.glew.pname}-${version}.tgz";
      sha256 = "sha256-BN6R5+Z2MDm8EZQAlc2cf4gLq6ghlqd2X3J6wFqZPJU=";
    };
  });

in with pkgs; [
    autoPatchelfHook
    electron_8
    glib
    gtk3
    libpng
    speex
    speexdsp
    zlib
    mpg123
    libsamplerate
    nodejs-12_x
    gomp
    libmpeg2
    SDL2
    SDL2_image
    libGL
    freetype
    sfml
    SDL2_ttf
    glew
    gcc-unwrapped
    xlibs.libXScrnSaver
    xlibs.libXtst
    alsaLib
    at-spi2-core
    nss
    xlibs.libXdamage
    nspr
    ffmpeg_3
]

