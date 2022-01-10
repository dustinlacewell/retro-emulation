{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = pkgs.callPackage ./deps.nix {};
}
