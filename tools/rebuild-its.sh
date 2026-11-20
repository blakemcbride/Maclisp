#!/bin/sh
# Rebuild the ITS/Maclisp disk image from the its/ source tree, inside a
# Docker container (the upstream build needs `expect`).  Takes 1.5-2 hours.
# See docs/REBUILDING.md.  The result is left in its/out/klh10/rp0.dsk;
# nothing in system/ is touched.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
ITS="$ROOT/its"

# The upstream Makefile expects every git submodule to be checked out.
# Only itstar, tapeutils and dasm (vendored here) and klh10 are used for a
# KLH10 build; give it klh10 from emulator/ and empty stand-ins for the rest.
if [ ! -f "$ITS/tools/klh10/configure" ]; then
    mkdir -p "$ITS/tools/klh10"
    cp -r "$ROOT/emulator/klh10/." "$ITS/tools/klh10/"
fi
for t in dasm itstar klh10 mldev simh sims supdup cbridge tapeutils tv11 \
         pdp6 vt05 tek4010 chaosnet-tools ncp; do
    mkdir -p "$ITS/tools/$t"
    [ -e "$ITS/tools/$t/.gitignore" ] || : > "$ITS/tools/$t/.gitignore"
done

docker build -q -t its-build - <<'DOCKER'
FROM debian:13
RUN apt-get update -q && apt-get install -y -q --no-install-recommends \
    git make gcc libc6-dev expect libncurses-dev autoconf automake libtool \
    pkg-config && rm -rf /var/lib/apt/lists/*
DOCKER

docker run --rm --memory=2g --memory-swap=2g \
    --user "$(id -u):$(id -g)" -e HOME=/tmp \
    -v "$ITS":/its -w /its its-build \
    make EMULATOR=klh10 GIT=true ${TARGET:-its}

cat <<MSG

Built its/out/klh10/rp0.dsk.  To install it as the pristine image:

  xz -9 -c its/out/klh10/rp0.dsk > system/rp0.dsk.xz
  sha256sum its/out/klh10/rp0.dsk | cut -d' ' -f1 > system/rp0.dsk.sha256
  cp its/build/klh10/@.ddt-u its/build/klh10/dskdmp.216bin system/
  ./run.sh --reset
MSG
