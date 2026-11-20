# Getting started with Maclisp on ITS

This guide gets you from `./run.sh` to writing, compiling and saving Maclisp
programs. It assumes you know some Lisp but have never used ITS.

Notation: `Ctrl-Z` means hold Control and press Z. `<Esc>` is the Escape key,
which ITS calls ALTMODE and echoes as `$`.

## 1. Booting

    ./run.sh

With Python 3 and `pexpect` installed, the boot dialogue is typed for you
and the date is set from the host clock. When you see

    [ITS is up and the date is set.  Type  :login yourname  then  :lisp

you are at DDT, the ITS command interpreter, not yet logged in.

Without `pexpect`, or with `./run.sh --manual`, do it by hand:

| You see | You type |
|---------|----------|
| `KLH10#` | `go` and Enter |
| `DSKDMP` | `its` and Enter, then `<Esc>` and `g` |
| `DB ITS 1652 IN OPERATION` | `Ctrl-Z` |
| the welcome message | `:pdset` and Enter |
| `PDSET` banner | `20C` (century), `261119D` (yymmdd`D`), `213000T` (hhmmss`T`), `!.` then `Q` |

The emulated KS10 has no battery clock, so ITS does not know the date until
`:pdset` is run. Files get wrong dates and some programs complain if you
skip it.

Messages from `dpimp` and `dpchaos` at boot, and `NET: TIMED OUT TRYING TO
COME UP` a minute later, are normal: ITS was built with network interfaces
and none is connected.

You are using the system console, so ITS occasionally prints its own
messages (`IT IS NOW ...`, `LOGIN .BATCH`) in the middle of your typing. They
do not affect your input.

## 2. Logging in and looking around

    :login lisper

Any name of up to six letters works; there are no passwords. DDT commands
start with a colon and end with Enter. DDT's prompt is `*`.

| To | Type |
|----|------|
| create your directory (once) | `:print lisper;..new. (udir)` then `:vk` |
| list a directory | `:listf lisper;` |
| type out a file | `:print lisper;fib lisp` |
| copy / delete | `:copy a b,c d` / `:delete a b` |
| list your jobs | `:listj` |
| kill the current job | `:kill` |
| on-line documentation | `:info` (`h` for help, `m` and a topic name for a menu item, `q` to quit) |
| log out | `:logout` |

A file name is `DEVICE: DIRECTORY; NAME1 NAME2`. Each name is at most six
characters, upper case. `NAME2` is a type (`LISP`, `FASL`) or a version
number; writing `>` as `NAME2` means "the highest-numbered version", or the
next one when writing. See `its/doc/DDT.md` for a cheat sheet that maps Unix
commands to DDT commands.

## 3. Running Lisp

    :lisp

    LISP 2156
    Alloc? n

    *

Answer `n` to `Alloc?` to take the default memory allocation. Lisp's prompt
is also `*`. Type a form; it is evaluated when the last parenthesis closes
(no Enter needed, though it does no harm).

    (plus 1 2)
    3
    (defun fact (n) (cond ((zerop n) 1) (t (times n (fact (sub1 n))))))
    FACT
    (fact 10.)
    15657400

That answer is right, in octal. See the next section.

| Key | Effect in Lisp |
|-----|----------------|
| `Ctrl-G` | Quit to top level (use it to leave a break loop) |
| `Ctrl-X` | Interrupt the running computation |
| `Ctrl-Z` | Return to DDT with Lisp suspended; `:continue` resumes it |
| Rubout/Backspace | Erase the last character |
| `(quit)` | Exit Lisp |

An error puts you in a break loop, shown by a message beginning with `;`
and a `;BKPT` line. You can inspect variables there. `Ctrl-G` returns to
top level.

## 4. What is different from a modern Lisp

- **Numbers are octal** on input and output. `10` is eight. A trailing dot
  forces decimal: `10.` is ten. To work in decimal:

      (setq base 10. ibase 10. *nopoint t)

  `base` is the output radix, `ibase` the input radix, and `*nopoint`
  suppresses the trailing dot that decimal output otherwise gets.
- **Symbols are upper case**; the reader upcases what you type.
- **Dynamic scope** in the interpreter. The compiler makes variables local
  unless declared `special`, so declare the ones you mean to be dynamic.
- **`/` is the escape character**, as `\` is in Common Lisp. Division is
  therefore written `//` (and `//$` for flonums). `\` is remainder.
- **Arithmetic comes in three flavours**: generic (`plus`, `times`,
  `difference`, `quotient`, `greaterp`), fixnum-only (`+ - * // < >`) and
  flonum-only (`+$ -$ *$ //$`). The fixnum operators do not overflow into
  bignums; `(times ...)` and `(expt 2 100.)` do.
- **Strings** are a late addition. `"abc"` reads as a symbol-like object
  that is good enough for file names and messages.
- **One namespace for most purposes, but functions live on property
  lists**: `(get 'fact 'expr)` is the lambda expression; after compiling,
  `(get 'fact 'subr)` is the machine code entry point. `FEXPR`s and
  `LEXPR`s (`(defun f n ...)`) also exist.
- Modern conveniences exist but are **autoloaded libraries**: `defmacro`,
  backquote, `setf`, `let`, `loop`, `format`, `defstruct`. The first use
  prints `;Loading ...` lines.
- `(status features)` lists what this Lisp has. `(status ...)` and
  `(sstatus ...)` are the general-purpose inquiry and control functions.

## 5. Files, the compiler and FASL

Load a source file:

    (load "lisper;fib lisp")

Compile it from DDT (not from inside Lisp):

    :complr lisper;fib lisp

    LISP COMPILER 2000 [in LISP 2156]
    Job COMPLR finished

The compiler runs as its own job. When it reports that it has finished,
type `:kill` to dispose of it. It writes `LISPER;FIB FASL` (the compiled
code) and `LISPER;FIB UNFASL` (messages). Then, in Lisp:

    (load "lisper;fib fasl")

In this system the compiled `(fib 20.)` runs about five times faster than
the interpreted one; `(runtime)` returns CPU time in microseconds if you
want to measure.

To write a file from Lisp:

    (setq f (open "lisper;out text" 'out))
    (print '(some data) f)
    (close f)

To make a stand-alone program (a saved Lisp image started with a colon
command), see `its/doc/hello-lisp.md`.

## 6. Editing with EMACS

This is the original EMACS, written in TECO. Tell ITS what kind of terminal
you have, then start it:

    :tctyp aaa
    :emacs

`:tctyp aaa` (Ann Arbor Ambassador) works with xterm and other ANSI
terminal emulators. Most basic keys are the ones GNU Emacs inherited:
`Ctrl-X Ctrl-F` find file, `Ctrl-X Ctrl-S` save, `Ctrl-X Ctrl-W` write to a
named file, `Ctrl-X Ctrl-C` return to DDT. After returning, `:kill` disposes
of the editor, or leave it and `:continue` it later.

A typical cycle is: edit `LISPER;FOO LISP` in EMACS, `Ctrl-X Ctrl-S`,
`Ctrl-X Ctrl-C`, switch to your Lisp job and `(load "lisper;foo lisp")`.
With several jobs, `:listj` shows them and `:job name` selects one.

Lisp can also run EMACS as an inferior and pass code back and forth
directly (the LEDIT package): see `its/doc/info/ledit.5`. The built-in structure editor is described in
`its/doc/_info_/lisp.edit`.

See `its/doc/EMACS.md` for more.

## 7. Moving files between the host and ITS

There is no network, so files travel on tape images.

**Host to ITS.** On the host:

    tools/to-its.sh lisper examples/*.lisp

writes `run/host.tape` and prints these instructions. In ITS:

    Ctrl-\                      (emulator prompt)
    KLH10> devmo mta0 host.tape
    KLH10> c
    :dump
    _load crdir
    FILE=lisper;* *
    FILE=                       (Enter alone; wait for E-O-T)
    _quit

`crdir` creates the directory if it does not exist. Host file `fib.lisp`
becomes `LISPER; FIB LISP`. Keep host names to six characters, a dot and six
characters. After `c`, press Enter if no prompt appears.

**ITS to host.** In ITS:

    Ctrl-\
    KLH10> devmo mta0 out.tape create
    KLH10> c
    :dump
    _dump
    FILE=lisper;* lisp
    FILE=
    TAPE NO=100                 (any number; answer y to "ARE YOU SURE")
    _quit
    Ctrl-\
    KLH10> devunmount mta0
    KLH10> c

Then on the host:

    tools/from-its.sh mydir

extracts to `mydir/lisper/fib.lisp` and so on. DUMP is documented in
`its/doc/_info_/dump.info`.

## 8. Shutting down

From DDT:

    :lock
    _5kill
    DO YOU REALLY WANT THE SYSTEM TO GO DOWN?
    y
    PLEASE ENTER A BRIEF MESSAGE TO USERS, ENDED BY ^C
    Ctrl-C
    _q
    :logout

Logging out skips the five-minute warning period. When ITS prints
`SHUTDOWN COMPLETE`:

    Ctrl-\
    KLH10> quit                 (confirm with y)

Your changes are in `run/rp0.dsk`. ITS writes to disk promptly, so killing
the emulator without shutting down usually loses nothing, but the clean way
is safer. `./run.sh --reset` throws the disk away and starts from the
pristine image.

## 9. Where to read more

Start with [the documentation index](README.md). The short list:

- The Pitmanual, <http://www.maclisp.info/pitmanual/>: the reference for
  exactly this era of Maclisp.
- `its/doc/info/lisp.15`, `lispa.5`, `lispio.4`, `lispc.6`: an on-line edit
  of the 1976 manual, also readable inside the system with `:info`.
- `docs/external/manuals/`: Moon's 1974 *MACLISP Reference Manual* and its
  later revisions.
- `its/doc/_info_/lisp.news`: the running log of every change to Maclisp.
