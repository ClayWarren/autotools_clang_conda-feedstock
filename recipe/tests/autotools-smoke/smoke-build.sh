#!/bin/bash
set -euxo pipefail

case "${target_platform}" in
  win-arm64)
    triplet=aarch64-w64-mingw32
    ;;
  win-64)
    triplet=x86_64-w64-mingw32
    ;;
  *)
    echo "unsupported target platform: ${target_platform}" >&2
    exit 1
    ;;
esac

autoreconf -vfi
./configure \
  --build="${triplet}" \
  --host="${triplet}" \
  --prefix="${PREFIX}"
patch_libtool
make -j"${CPU_COUNT:-2}"
make check
make install
