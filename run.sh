#!/bin/sh
# Boot ITS with Maclisp under the KLH10 emulator.
#   ./run.sh           boot (builds the emulator and unpacks the disk on first use)
#   ./run.sh --reset   discard run/ and start again from the pristine disk image
#   ./run.sh --manual  do not automate the boot dialogue
# If python3 with the pexpect module is present, the boot dialogue and the
# setting of the date are done for you (tools/its.py); otherwise, or with
# --manual, you type them yourself as described in docs/GETTING-STARTED.md.
set -e
ROOT=$(cd "$(dirname "$0")" && pwd)
RUN="$ROOT/run"

MANUAL=no
for arg; do
    case "$arg" in
        --reset) rm -rf "$ROOT/run" ;;
        --manual) MANUAL=yes ;;
        *) echo "usage: $0 [--reset] [--manual]" >&2; exit 2 ;;
    esac
done

[ -x "$ROOT/bin/kn10-ks-its" ] || "$ROOT/build.sh"

mkdir -p "$RUN"
if [ ! -f "$RUN/rp0.dsk" ]; then
    echo "Unpacking pristine disk image into run/ ..."
    xz -dc "$ROOT/system/rp0.dsk.xz" > "$RUN/rp0.dsk.tmp"
    want=$(cat "$ROOT/system/rp0.dsk.sha256")
    got=$(sha256sum "$RUN/rp0.dsk.tmp" | cut -d' ' -f1)
    if [ "$want" != "$got" ]; then
        echo "Disk image checksum mismatch" >&2
        exit 1
    fi
    mv "$RUN/rp0.dsk.tmp" "$RUN/rp0.dsk"
fi
cp "$ROOT/system/its.ini" "$ROOT/system/@.ddt-u" "$ROOT/system/dskdmp.216bin" "$RUN/"
# KLH10 looks for its device helper programs in the current directory.
for dp in dprpxx dptm03 dpimp dpchaos; do
    ln -sf "$ROOT/bin/$dp" "$RUN/$dp"
done

if [ $MANUAL = no ] && python3 -c 'import pexpect' 2>/dev/null; then
    exec python3 "$ROOT/tools/its.py"
fi

cat <<'MSG'

  At "KLH10#" type:        go
  At "DSKDMP" type:        its  <Enter>  then  <Esc> g
  After "IN OPERATION":    Ctrl-Z, then  :pdset  to set the date (see docs),
                           then  :login yourname
  Start Maclisp with:      :lisp
  Ctrl-\ returns to the emulator ("KLH10>"); "quit" exits it.
  See docs/GETTING-STARTED.md.

MSG
cd "$RUN"
exec "$ROOT/bin/kn10-ks-its" its.ini
