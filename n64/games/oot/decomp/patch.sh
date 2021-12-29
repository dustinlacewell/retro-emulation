#!/usr/bin/env bash

set -ex

interp=$(patchelf --print-interpreter $(which env))
for version in 5.3 7.1; do
    for tool in cc cfe uopt ugen as1; do
        patchelf --set-interpreter $interp ./tools/ido_recomp/linux/$version/$tool
    done
done
