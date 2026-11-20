# Maclisp

A complete, stand-alone, runnable MIT [Maclisp](https://en.wikipedia.org/wiki/Maclisp)
system: PDP-10 Maclisp 2156 with its compiler and libraries, running on the
ITS operating system under the KLH10 emulator. Everything is in this one
repository: the emulator source, a ready-to-boot disk image, the full source
of Maclisp and of ITS, and a documentation archive.

Maclisp (1966–1980s, MIT Project MAC) is the ancestor of Lisp Machine Lisp,
NIL, Franz Lisp and Common Lisp. Macsyma, SHRDLU, the first Scheme and the
first EMACS-with-Lisp environments were written in it; all of those are on
the disk image too.

## Quick start

Requirements: a C compiler, GNU make and `xz`. Python 3 with `pexpect` is
optional but recommended (it automates the boot dialogue and sets the date).

    ./build.sh
    ./run.sh

`build.sh` compiles the KLH10 emulator and the `itstar` tape tool from the
source in this repository and installs them in `bin/`. It takes under a
minute and needs no root. (`run.sh` runs it for you if `bin/` is missing.)

`run.sh` unpacks the pristine disk image into `run/` on first use and boots
ITS. When you see

    [ITS is up and the date is set. ...]

log in under any name and start Lisp:

    :login yourname
    :lisp

    LISP 2156
    Alloc? n

    *
    (defun fact (n) (cond ((zerop n) 1) (t (times n (fact (sub1 n))))))
    FACT
    (fact 30.)
    642375433417455031357535652400000000

`(quit)` leaves Lisp. That answer is in **octal**: Maclisp reads and prints
octal unless told otherwise (a trailing dot marks a decimal number); see the
guide. Warnings from `dpimp`/`dpchaos` and the message
`NET: TIMED OUT TRYING TO COME UP` are expected: no network is attached.

To shut down cleanly:

    :lock
    _5kill            (answer y, then Ctrl-C to end the message)
    _q
    :logout           (wait for SHUTDOWN COMPLETE)
    Ctrl-\
    KLH10> quit

`./run.sh --reset` discards `run/` and starts again from the pristine image.
`./run.sh --manual` skips the automation.

**Read [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md) next**: logging in,
files and directories, the compiler, EMACS, moving files between the host
and ITS, and a short Maclisp orientation for people who know a modern Lisp.

## Layout

| Path | Contents |
|------|----------|
| `run.sh`, `build.sh` | Boot the system; build the emulator and tape tool |
| `system/` | Pristine ITS disk image (`rp0.dsk.xz`), boot loader, emulator configuration |
| `emulator/klh10/` | KLH10 PDP-10 emulator source (PDP-10/klh10, one local fix; see below) |
| `its/` | Snapshot of [PDP-10/its](https://github.com/PDP-10/its): all source, docs, bootstrap binaries and build scripts the disk image was built from |
| `its/src/l`, `comlap`, `lspsrc`, `nilcom`, `libdoc` | **The Maclisp source**; see [docs/SOURCES.md](docs/SOURCES.md) |
| `docs/` | Guides written for this repository, plus [an index](docs/README.md) of all documentation |
| `docs/external/` | Manuals, MIT AI memos, papers and mailing-list archives collected from public archives; see its `MANIFEST.md` |
| `examples/` | Small Maclisp programs used in the guide and by the self-test |
| `tools/` | Boot automation, host ↔ ITS file transfer, self-test, rebuild script |

## What is on the disk

- **Maclisp 2156** (`:lisp`), the last MIT version, with bignums, NEWIO,
  hunks, SFAs and the full autoload library (LOOP, FORMAT, DEFMACRO, SETF,
  DEFSTRUCT/DEFVST, backquote, GRINDEF, TRACE, the stepper, ...).
- **COMPLR 2000** (`:complr`), the compiler, and FASLAP.
- **EMACS** and TECO, with the LEDIT/LISPT Lisp interfaces.
- On-line documentation in `:info`.
- Programs written in Maclisp: Macsyma (`:macsyma`), SHRDLU (`SHRDLU;`),
  the original Scheme (`SCHEME;`), LLOGO (`LLOGO;`).
- The rest of ITS: MIDAS, DDT, Muddle, Zork, and all the sources (the
  Maclisp ones are in `L;`, `COMLAP;`, `LSPSRC;`, `NILCOM;`, `LIBDOC;`).

## Verifying

    tools/selftest.py --reset

boots from the pristine image, loads files from the host, exercises the
interpreter, compiler and libraries, copies a file back out and shuts down.
It needs Python 3 with `pexpect` and takes a few minutes.

## Rebuilding the disk image from source

`system/rp0.dsk.xz` was built from the `its/` tree with the upstream build
procedure. [docs/REBUILDING.md](docs/REBUILDING.md) explains how to repeat it.

## Provenance and licences

| Component | Source | Licence |
|-----------|--------|---------|
| ITS, Maclisp, and everything in `its/` | PDP-10/its commit `f2d00b83` (2026-10-13) | `its/LICENSE` (MIT licence, for the directories it lists) and `its/COPYING` (GPL v3, for files that refer to it); the remaining files carry no explicit licence |
| KLH10 | PDP-10/klh10 commit `6d733f2a` (2026-08-03) | `emulator/klh10/LICENSE` |
| itstar, tapeutils, dasm | in `its/tools/` | GPL (see each directory) |
| `docs/external/` | bitsavers, CHM Software Preservation Group, SAILDART, DTIC, NASA and others | Per document; see `docs/external/MANIFEST.md` |
| Scripts and guides written for this repository | — | MIT licence (`LICENSE`) |

Local change to KLH10: `src/dvlhdh.c` no longer waits for the IMP helper
process to acknowledge a quit when that process has already exited. Without
it, `quit` hangs when the emulator is run without root.

Kent Pitman's *Revised Maclisp Manual* (the "Pitmanual"), the best Maclisp
reference, may not be copied; read it at <http://www.maclisp.info/pitmanual/>.
