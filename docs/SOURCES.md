# Where the Maclisp source lives

All paths are under `its/`, a snapshot of <https://github.com/PDP-10/its>.
On ITS a file is `DIR; NAME1 NAME2`; in the snapshot that is
`src/dir/name1.name2` (the second name is usually a version number).
Inside the running system the same files are on disk, e.g. `L; QIO 760`
is `its/src/l/qio.760`.

## The interpreter and runtime — `src/l/` (MIDAS assembler)

Assembled by `:MIDAS .TEMP.;_L;*LISP`; `*lisp` pulls in the other files.

| File | Contents |
|------|----------|
| `*lisp` | Main file: interpreter (EVAL/APPLY), top level, interrupts, system interface |
| `defns` | Accumulator, UUO and macro definitions; assembly switches |
| `macs` | MIDAS macros used throughout |
| `alloc` | Start-up, the `ALLOC?` dialogue, storage allocation |
| `gcbib` | Garbage collector, storage spaces, BIBOP type tables |
| `arith` | Fixnum/flonum arithmetic |
| `bignum` | Bignum arithmetic |
| `array` | Arrays |
| `reader` | `READ`, readtables, reader macros |
| `print` | `PRINT`, `PRIN1`, formatting, file-handling functions |
| `qio` | "New I/O": file objects, `OPEN`, `LOAD`, TTY handling, cursor control |
| `fasloa` | `FASLOAD`, the loader for compiled (FASL) files |
| `error` | Error handlers, messages, break loops |
| `status` | `STATUS` / `SSTATUS` |
| `struct` | Initial list structure: the built-in atoms, obarray, autoload properties |
| `ulap` | LAP support and assorted subrs |
| `allfil` | `ALLFILES`, `MAPALLFILES` (directory enumeration) |
| `humble` | Inferior-job control package (used by `LEDIT`) |
| `bltarr` | `BLTARRAY` |
| `getmid` | `GETMIDASOP` (opcode decoding for LAP) |
| `lchnsp` | Chaosnet support |
| `slave` | Display slave interface |
| `purep` | `PUREP` / `WRITEABLEP` |

## The compiler — `src/comlap/` (Lisp)

`COMPLR` compiles Lisp to LAP; `FASLAP` assembles LAP into FASL files.

| File | Contents |
|------|----------|
| `complr` | The compiler proper (code generation) |
| `phas1` | Phase 1: macro expansion, variable analysis |
| `comaux` | Auxiliary functions |
| `cdmacs` | Declarations and macros for the compiler itself |
| `faslap` | Assembler producing FASL files |
| `maklap` | Command-line / file-name parser, driver |
| `initia`, `srctrn` | Initialization, source-to-source transformations |
| `ccload` | Loads the pieces and dumps `TS COMPLR` |
| `ledit` | `LEDIT`: the Lisp ↔ EMACS interface |

## Out-of-core system functions — `src/lspsrc/`

Autoloaded on first use from the `LISP;` directory.

| File | Contents |
|------|----------|
| `grind`/`gfile`, `grinde`/`gfn` | Pretty-printer: `GRIND` (files), `GRINDEF` (functions) |
| `trace` | `TRACE` |
| `edit` | The built-in structure editor ("Binford editor") |
| `sort` | `SORT`, `SORTCAR` |
| `lap` | In-core LAP assembler |
| `extend`, `extbas`, `extmac`, `extstr`, `exthuk`, `extsfa`, `extmdf`, `sendi` | The EXTEND object/class system and `SEND` |
| `vector`, `bits`, `straux` | Vectors, bit strings, string support |
| `mlmac`, `umlmac`, `mlsub` | Standard macros (`IF`, `WHEN`, `DOLIST`, ...) |
| `cerror` | `CERROR`, `FERROR` |
| `descri` | `DESCRIBE` |
| `dumpar` | `DUMPARRAYS` / `LOADARRAYS` |
| `gcdemn` | Standard GC daemon |
| `querio` | Query I/O |
| `nilaid`, `funcel`, `ldbhlp`, `lexprf` | NIL-compatibility and byte helpers |
| `reap` | Finds reapable old Lisp dumps |

## NIL-compatible library — `src/nilcom/`

Code shared with NIL and Lisp Machine Lisp; most of what makes late
Maclisp feel modern.

| File | Contents |
|------|----------|
| `backq` | Backquote |
| `defmac`, `defmax`, `macaid` | `DEFMACRO`, `DEFUN` with `&`-keywords |
| `setf`, `defset` | `SETF`, `PUSH`, `POP`, `DEFSETF` |
| `let` | `LET`, `LET*`, destructuring `DESETQ` |
| `defvst`, `defvsx`, `defvsy` | `DEFVST` structures |
| `sharpm`, `sharpa`, `sharpc` | The `#` reader macro and `#+`/`#-` conditionals |
| `string`, `subseq` | Strings, characters, sequences |
| `drammp`, `lsets` | `DEL`/`REM`/`ASS`/`MEM`/`POS` families, list sets |
| `errck`, `evonce`, `yesnop`, `thread`, `subloa`, `cnvd`, `vsaid` | Error checking, `Y-OR-N-P`, autoload preamble, misc. |

## Libraries — `src/libdoc/`

About 115 user-contributed packages (LOOP, FORMAT, STRUCT/DEFSTRUCT, the
stepper, DRIBBLE, etc.), compiled into `LIBLSP;`. Their documentation is in
`doc/libdoc/` and at the top of each source file.

## Other directories of interest

| Path | Contents |
|------|----------|
| `src/lisp/` | FASL definitions, `SHARAB` (sharable-dump support) |
| `bin/lisp/`, `bin/comlap/`, `bin/liblsp/` | Bootstrap binaries used by the build |
| `build/lisp.tcl` | The script that builds Maclisp, the compiler and the libraries |
| `src/hello/` | "Hello world" in Maclisp, with dump script |
| `src/teach/` | TEACH;ULISP, an interactive Lisp tutor |
| `src/macsym/`, `src/maxsrc/`, `src/jpg/`, ... | Macsyma, the largest Maclisp program |
| `src/shrdlu/` | SHRDLU (Winograd), in Maclisp + Micro-Planner |
| `src/scheme/` | The original Sussman & Steele Scheme interpreter, in Maclisp |
| `src/llogo/` | LLOGO: Logo implemented in Maclisp |
| `src/emacs1/lispt.*` | EMACS LISPT library (talks to `LEDIT`) |
| `src/gls/`, `doc/gls/` | Guy Steele's files, including design notes |
