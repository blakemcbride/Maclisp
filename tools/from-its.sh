#!/bin/sh
# Extract files from a DUMP tape image written by ITS.
#   tools/from-its.sh [DESTDIR]        (default: ./from-its)
# "DIR; NAME EXT" is written to DESTDIR/dir/name.ext.
#
# To write the tape, in the running system:
#   Ctrl-\                       (get the KLH10> prompt)
#   devmo mta0 out.tape create
#   c
#   :dump
#   _dump
#   FILE=mydir;* *               (or  mydir;name ext)
#   FILE=                        (just Enter)
#   TAPE NO=100                  (any number; answer Y if asked "ARE YOU SURE")
#   _quit
#   Ctrl-\  then  devunmount mta0  then  c
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
[ -x "$ROOT/bin/itstar" ] || "$ROOT/build.sh"
dest=${1:-from-its}
mkdir -p "$dest"
"$ROOT/bin/itstar" -xvf "$ROOT/run/out.tape" -C "$dest"
