# Documentation index

Three layers: guides written for this repository, the documentation that
ships inside ITS (`its/doc/`, also on the disk image), and documents
collected from public archives (`docs/external/`).

## Start here

| Document | What it is |
|----------|------------|
| [GETTING-STARTED.md](GETTING-STARTED.md) | Boot, log in, run Lisp, compile, edit, move files, shut down |
| [SOURCES.md](SOURCES.md) | Map of the Maclisp source: interpreter, compiler, libraries |
| [REBUILDING.md](REBUILDING.md) | How the disk image is built from source |
| [The Pitmanual](http://www.maclisp.info/pitmanual/) | Kent Pitman's *Revised Maclisp Manual* (1983, web edition 2007). The best reference for this Maclisp. Copyright forbids copying it, so it is linked, not included |

## Reference manuals

| Document | Notes |
|----------|-------|
| `external/manuals/Moon-MACLISP-Reference-Manual-Rev0-1974-04-08.pdf` | The "Moonual": David Moon's 1974 reference manual |
| `external/manuals/MACLISP-Reference-Manual-1975-12-17.pdf`, `...-1978-07-27.pdf` | Later revisions of the manual |
| `external/manuals/Maclisp-Reference-Manual-1979-03-03-LISP.DOC.txt` | 1979 text edition |
| `../its/doc/info/lisp.15`, `lispa.5`, `lispio.4` | INFO-format edit of the 1976 manual: language, system (break loops, debugging), I/O |
| `../its/doc/info/lispc.6` | The compiler, COMPLR |
| `external/manuals/Touretzky-Summary-of-MacLisp-Functions-and-Flags-1979.pdf` | Compact function summary |
| `external/manuals/Bawden-Burke-Hoffman-Maclisp-Extensions-MIT-LCS-TM-203-1981-*.pdf` | DEFMACRO, backquote, SETF, DEFSTRUCT, FORMAT and other late extensions |
| `external/manuals/Burke-Moon-LOOP-Iteration-Macro-*.pdf` | The LOOP macro |
| `external/sail/` | Stanford copies of Maclisp notes, including the 1977 draft of the never-finished new manual |

## What changed, and when

| Document | Notes |
|----------|-------|
| `../its/doc/_info_/lisp.news` | LISP NEWS: every user-visible change, 1970s–1980s (400 KB) |
| `../its/doc/_info_/lisp.recent` | The most recent changes |
| `external/mailing-lists/bug-lisp/` | BUG-LISP mail archive, 1978–83 (open `index.html`) |
| `external/mailing-lists/lisp-forum/` | LISP-FORUM language-design discussion, 1980–86 |

## Individual features (in `../its/doc/_info_/`)

| File | Topic |
|------|-------|
| `lisp.newio`, `newio.stuff` | The "new I/O" system: file objects, OPEN |
| `lisp.sfa` | Software file arrays (user-defined streams) |
| `lisp.loop`, `lisp.format`, `lisp.string` | LOOP, FORMAT, strings |
| `lisp.defvst`, `lisp.extend`, `lisp.send` | Structures, the EXTEND class system, message sending |
| `lisp.sharpm`, `lisp.sharpc` | The `#` reader macro and `#+`/`#-` conditionals |
| `lisp.trace`, `lisp.stepmm`, `step.info` | TRACE and the stepper |
| `lisp.edit` | The built-in structure editor |
| `lisp.cursor`, `lisp.whovar` | Cursor control, the who-line |
| `fasl.format`, `fasbin.format` | FASL file format |
| `cgol.doc` | CGOL, Pratt's algebraic syntax for Maclisp |

Also: `../its/doc/info/ledit.5` and `lispt.22` (Lisp ↔ EMACS interfaces),
`../its/doc/libdoc/` (library packages; each `../its/src/libdoc/` source
file also begins with its own documentation), `../its/doc/teach/` (the
ULISP tutor), `../its/doc/hello-lisp.md` (making a stand-alone program).

## Implementation and design

| Document | Notes |
|----------|-------|
| `external/memos/AIM-420-Steele-Data-Representations-in-PDP-10-MacLISP-1977.pdf` | How every data type is laid out; BIBOP |
| `external/memos/AIM-421-Steele-Fast-Arithmetic-in-MacLISP-1977.pdf` | Why compiled Maclisp arithmetic rivalled FORTRAN |
| `external/papers/Proceedings-1977-MACSYMA-Users-Conference-NASA-CP-2012.pdf` | Includes the papers above and White's "LISP: Program is Data" |
| `external/papers/White-LISP-Program-is-Data-Historical-Perspective-on-MacLISP-1977.pdf` | Jon L White's history of Maclisp |
| `external/papers/White-NIL-A-Perspective-1979.pdf` | Where Maclisp was heading |
| `../its/doc/gls/` | Guy Steele's notes: CONS, data objects, fast arithmetic |
| `external/memos/AIM-210-Golden-Users-Guide-to-the-LISCOM-Lisp-Compiler-1970.pdf` | The early compiler |

## Early history: PDP-6 LISP

`external/memos/` has the AI memos from Maclisp's first years: AIM-98 and
AIM-116A (*PDP-6 LISP*), AIM-152 (*LAP*), AIM-157 (*Time-Sharing LISP*),
AIM-190 (*An Interim LISP User's Guide*), AIM-199 (*The Function of FUNCTION
in LISP*). `external/history/` has the SAIL LISP news file (1969–78) and
Stallman's "My Lisp Experiences".

## ITS itself

| Document | Notes |
|----------|-------|
| `../its/doc/DDT.md` | DDT cheat sheet for Unix users |
| `../its/doc/new-user.md`, `EMACS.md`, `TECO.md`, `programs.md` | Upstream guides |
| `../its/doc/_info_/its.primer`, `../its/doc/info/ddt.33` | ITS primer; full DDT manual |
| `../its/doc/_info_/dump.info`, `../its/doc/DUMP-itstar.md` | Tapes |
| `external/its-background/` | ITS 1.5 Reference Manual (AIM-161A), ITS Status Report, DDT manual |

## Other Maclisps

Maclisp also ran on Multics, TOPS-10, TOPS-20 and WAITS. `external/multics/`
has Multics Maclisp material; `external/ai-doc-dir/` includes the notice
about the TOPS-10/20 versions. This repository runs the ITS version, which
was the primary one.

`external/MANIFEST.md` lists every external file with its source URL and
redistribution status, and the documents that are linked rather than
included.
