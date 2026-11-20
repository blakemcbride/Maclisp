#!/bin/sh
# Build the KLH10 emulator (KS10 / ITS flavour) and the itstar tape tool into bin/.
set -e
ROOT=$(cd "$(dirname "$0")" && pwd)
BLD="$ROOT/build/klh10"
mkdir -p "$BLD" "$ROOT/bin"
cd "$BLD"
CONFFLAGS_USR="-DKLH10_DEV_DPTM03=0 $CONFFLAGS_USR"
export CONFFLAGS_USR
if [ ! -f Makefile ]; then
    "$ROOT/emulator/klh10/configure" --bindir="$ROOT/bin"
fi
make -C bld-ks-its
make -C bld-ks-its install

# itstar: reads and writes ITS DUMP tape images (host <-> ITS file transfer)
mkdir -p "$ROOT/build/itstar"
cp "$ROOT"/its/tools/itstar/*.[ch] "$ROOT/its/tools/itstar/Makefile" "$ROOT/build/itstar/"
make -C "$ROOT/build/itstar" itstar
cp "$ROOT/build/itstar/itstar" "$ROOT/bin/itstar"

echo "Built $ROOT/bin/kn10-ks-its and $ROOT/bin/itstar"
