# Rebuilding the disk image from source

`system/rp0.dsk.xz` is not a relic copied from an old machine. It was built
from the source in `its/` by the upstream PDP-10/its build: a set of
`expect` scripts (`its/build/*.tcl`) that boot a minimal ITS from tape under
the emulator and then assemble and compile everything inside it, including
Maclisp, the compiler and the Lisp libraries (`its/build/lisp.tcl`).

## Procedure

Requirements: Docker (used only to get `expect` and a known toolchain).

    tools/rebuild-its.sh

This takes 1.5–2 hours and leaves the new image in `its/out/klh10/rp0.dsk`.
The script prints the commands to install it as the pristine image.

What the script does:

1. Puts a copy of `emulator/klh10` at `its/tools/klh10`, and creates empty
   stand-ins for the upstream git submodules a KLH10 build does not use.
   `itstar`, `tapeutils` and `dasm`, which it does use, are vendored in
   `its/tools/`.
2. Builds a Debian container with gcc, make, autoconf and expect.
3. Runs `make EMULATOR=klh10 its` in `its/`, capped at 2 GB of RAM.

To build without Docker, install `expect` and run the same `make` command
in `its/` after step 1; see `its/README.md` and `its/doc/build.md`.

## Differences from an upstream checkout

- `its/` has no git history, so files that have no entry in
  `its/build/timestamps.txt` get the checkout time rather than their last
  commit date (`its/build/stamp.sh` prints harmless `touch` errors).
- `its/tools/dasm` omits upstream's `test/` and `samples/` directories.
- The build configures ITS as machine `DB` with the example network
  addresses in `its/conf/network`.

## How Maclisp itself is built

From `its/build/lisp.tcl`:

1. `:MIDAS .TEMP.;_L;*LISP` assembles the interpreter from `L;`.
2. The result is loaded, purified and dumped as `SYS;PURQIO 2156`;
   `SYS;TS LISP` is a link to it.
3. Lisp loads `COMLAP;CCLOAD`, which loads the compiler's FASL files (from
   the bootstrap binaries in `its/bin/comlap`) and dumps `SYS;TS COMPLR`.
4. The compiler compiles the out-of-core system files from `LSPSRC;` and
   `NILCOM;` into `LISP;`, and the libraries from `LIBDOC;` into `LIBLSP;`.
5. The compiler is then used to recompile itself.

Inside the running system you can repeat any step by hand; all the sources
are on disk under the same directory names.
