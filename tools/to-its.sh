#!/bin/sh
# Put host files on a DUMP tape image that ITS can read.
#   tools/to-its.sh ITSDIR file...
# Each file "name.ext" becomes "ITSDIR; NAME EXT" (names are truncated to
# six characters by ITS).  The tape is written to run/host.tape.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
if [ $# -lt 2 ]; then
    echo "usage: $0 ITSDIR file..." >&2
    exit 2
fi
[ -x "$ROOT/bin/itstar" ] || "$ROOT/build.sh"
dir=$(echo "$1" | tr 'A-Z' 'a-z')
shift
tmp=$(mktemp -d)
trap 'rm -rf "${tmp:?}"' EXIT
mkdir "$tmp/$dir"
for f; do
    cp "$f" "$tmp/$dir/$(basename "$f" | tr 'A-Z' 'a-z')"
done
mkdir -p "$ROOT/run"
"$ROOT/bin/itstar" -cvf "$ROOT/run/host.tape" -C "$tmp" "$dir"
cat <<MSG

Tape written to run/host.tape.  To read it, in the running system:

  Ctrl-\\                       (get the KLH10> prompt)
  devmo mta0 host.tape
  c                            (continue ITS; press Enter if no prompt shows)
  :dump
  _load crdir
  FILE=$dir;* *
  FILE=                        (just Enter; wait for E-O-T)
  _quit
MSG
