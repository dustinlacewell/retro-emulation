{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = pkgs.callPackage ./deps.nix {};
#   shellHook = ''
#     cp ${./sfml_audio.node} ${out}/ModLoader64/emulator/sfml_audio.node;
#   '';
}
