#!/usr/bin/env python3
"""End-to-end test of the Maclisp system.

Boots ITS from a pristine disk, moves files in from the host on a tape,
runs the interpreter, the compiler and several autoloaded libraries,
moves a file back out, and shuts down cleanly.  Takes a few minutes.

    tools/selftest.py --reset      (--reset is required: run/ is discarded)
"""
import os, shutil, subprocess, sys, tempfile, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from its import ITS, ROOT

if '--reset' not in sys.argv[1:]:
    sys.exit(__doc__)

log = open(os.path.join(ROOT, 'selftest.log'), 'w')
its = ITS(log=log, reset=True)
failures = []


def cmd(s, wait=4):
    its.type(s + '\r')
    time.sleep(wait)


def check(name, form, want, wait=60):
    """Evaluate FORM in Lisp and require WANT in what it prints."""
    its.type(form + '\r')
    try:
        its.expect(want, timeout=wait)
        print('ok    ', name)
    except Exception:
        print('FAILED', name)
        failures.append(name)
    time.sleep(1)


def lisp():
    cmd(':lisp', 1)
    its.respond('Alloc?', 'n')
    its.expect('*')


def klh(*commands):
    its.type('\034')
    for c in commands:
        its.respond('KLH10>', c + '\r')
    time.sleep(1)


its.boot()
its.login('lisper')
print('ok     boot, date, login')
cmd(':print lisper;..new. (udir)')      # create the LISPER directory
cmd(':vk')

# host -> ITS
tmp = tempfile.mkdtemp()
os.mkdir(os.path.join(tmp, 'lisper'))
for f in ('fib.lisp', 'fact.lisp', 'modern.lisp'):
    shutil.copy(os.path.join(ROOT, 'examples', f), os.path.join(tmp, 'lisper', f))
subprocess.run([os.path.join(ROOT, 'bin', 'itstar'), '-cf',
                os.path.join(ROOT, 'run', 'host.tape'), '-C', tmp, 'lisper'],
               check=True, stdout=subprocess.DEVNULL)
shutil.rmtree(tmp)
klh('devmo mta0 host.tape', 'c')
its.type(':dump\r')
its.respond('_', 'load crdir\r')
its.respond('FILE=', 'lisper;* *\r')
its.respond('FILE=', '\r')
its.expect('E-O-T', timeout=120)
its.respond('_', 'quit\r')
its.expect(':KILL')
print('ok     host -> ITS tape')

# interpreter
lisp()
check('arithmetic', '(plus 1 2)', '3 ')
check('load source', '(load "lisper;fib lisp")', 'T')
check('interpreted fib', '(fib 15.)', '1142 ')
check('load fact', '(load "lisper;fact lisp")', 'T')
check('bignums', '(fact 25.)', '6324500606375411017360000000')
check('LOOP + DEFMACRO + backquote + LET', '(load "lisper;modern lisp")', 'T', 120)
check('LOOP result', '(squares 5)', '(1 4 9 16 25)', 120)
check('FORMAT', '(show 3)', 'The first 3 squares are (1 4 9)', 120)
check('SETF', "(progn (setq l (list 1 2 3)) (setf (cadr l) 'two) l)", '(1 TWO 3)', 120)
check('SORT', "(sort (list 3 1 2) (function <))", '(1 2 3)', 120)
check('GRINDEF', '(grindef fact)', '(DEFUN FACT (N)', 120)
check('error break', '(car 5)', 'ILLEGAL DATUM')
its.type('\x07')                         # ^G: back to top level
time.sleep(2)
cmd('(quit)')

# compiler
its.type(':complr lisper;fib lisp\r')
try:
    its.expect('Job COMPLR finished', timeout=300)
    print('ok     COMPLR ran')
except Exception:
    print('FAILED COMPLR ran')
    failures.append('COMPLR')
time.sleep(3)
cmd(':kill')
lisp()
check('load FASL', '(load "lisper;fib fasl")', '\n', 60)
check('compiled fib', '(fib 20.)', '15155 ')
check('compiled is a SUBR', "(get 'fib 'subr)", '#')
cmd('(quit)')

# ITS -> host
out = os.path.join(ROOT, 'run', 'out.tape')
klh('devmo mta0 out.tape create', 'c')
its.type(':dump\r')
its.respond('_', 'dump\r')
its.respond('FILE=', 'lisper;fib fasl\r')
its.respond('FILE=', '\r')
its.respond('TAPE NO=', '100\r')
if its.expect(['ARE YOU SURE', '_'], timeout=60) == 0:
    its.type('y')
    its.expect('_', timeout=60)
time.sleep(2)
its.type('quit\r')
its.expect(':KILL')
klh('devunmount mta0', 'c')
tmp = tempfile.mkdtemp()
subprocess.run([os.path.join(ROOT, 'bin', 'itstar'), '-xf', out, '-C', tmp],
               stdout=subprocess.DEVNULL)
if os.path.exists(os.path.join(tmp, 'lisper', 'fib.fasl')):
    print('ok     ITS -> host tape')
else:
    print('FAILED ITS -> host tape')
    failures.append('ITS -> host')
shutil.rmtree(tmp)

its.shutdown()
print('ok     shutdown')
print('\n%s (console transcript in selftest.log)'
      % ('ALL PASSED' if not failures else 'FAILURES: ' + ', '.join(failures)))
sys.exit(1 if failures else 0)
