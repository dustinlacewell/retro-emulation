{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
    deps = callPackage ./deps.nix {};

    version = "2.0.30";
    url = "https://github.com/hylian-modding/ModLoader64/releases/download/v${version}/ModLoader-linux64.zip";
    tempfile = "/tmp/ModLoader-linux64.zip";
    installPath = "~/.config/ModLoader64";

    # fetch github package svanderburg/nix-patchtools
    autopatchelf_src = pkgs.fetchFromGitHub {
        rev = "master";
        sha256 = "sha256-anuSZw0wcKtTxszBZh2Ob/eOftixEZzrNC1sCaQzznk=";
        repo = "nix-patchtools";
        owner = "svanderburg";
    };

    autopatchelf = import autopatchelf_src;

in pkgs.runCommandCC "ml64-installer" { buildInputs = [ autopatchelf patchelf ]; } ''
        cat <<EOF > $out
        #!${stdenv.shell}

        export PATH=$PATH:${patchelf}/bin
        export libs=${pkgs.lib.makeLibraryPath (deps ++ [ glibc speex ])}
        export autoPatchelfIgnoreMissingDeps=true

        download() {
            # download package from github
            ${curl}/bin/curl -L ${url} -o ${tempfile}
        }

        unpack() {
            # unzip package as ~/.config/ModLoader64
            ${unzip}/bin/unzip ${tempfile} -d ${installPath}
        }

        patch() {
            ${autopatchelf}/bin/autopatchelf ${installPath}/ModLoader/
            cp ${./sfml_audio.node} ${installPath}/ModLoader/emulator/sfml_audio.node
            echo "Patching complete."
        }

        install() {
            if [ ! -d ${installPath}/ModLoader ]; then
                echo "Installing ModLoader64..."
                mkdir -p ${installPath}
                download
                unpack
                patch
                link
                run
            fi
        }

        link() {
            # if ${installPath}/roms doesn't exist, create it
            if [ ! -d ${installPath}/roms ]; then
                mkdir -p ${installPath}/roms
            fi
            # if ${installPath}/mods doesn't exist, create it
            if [ ! -d ${installPath}/mods ]; then
                mkdir -p ${installPath}/mods
            fi
            # link ${installPath}/ModLoader/roms to ../
            echo "Linking roms..."
            rm -fr ${installPath}/ModLoader/roms
            ln -s ${installPath}/roms ${installPath}/ModLoader/roms
            echo "Linking mods..."
            rm -fr ${installPath}/ModLoader/mods
            ln -s ${installPath}/mods ${installPath}/ModLoader/mods
        }

        run() {
            echo "Running with args: \$@"
            cd ${installPath}/ModLoader/ && \
            ${nodejs-12_x}/bin/node ${installPath}/ModLoader/src/index.js -s ${installPath}/ModLoader/ "\''${@}"
        }

        install
        run "\$@"

        EOF
        chmod +x $out
    ''