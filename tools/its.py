#!/usr/bin/env python3
"""Drive ITS on KLH10 from Python (needs the pexpect module).

Run directly (this is what ./run.sh does when pexpect is available) it
boots ITS, sets the date from the host clock, and hands you the console.
As a module it is used by tools/selftest.py to script the system.
"""
import os, sys, time, pexpect

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ESC = '\033'


class ITS:
    def __init__(self, log=None, timeout=120, reset=False):
        args = ['--manual'] + (['--reset'] if reset else [])
        self.p = pexpect.spawn(os.path.join(ROOT, 'run.sh'), args, cwd=ROOT,
                               encoding='latin-1', timeout=timeout)
        self.p.logfile_read = log

    def expect(self, pat, timeout=-1):
        return self.p.expect_exact(pat, timeout=timeout)

    def type(self, s, delay=0.03):
        """Type slowly; ITS drops characters sent in bursts."""
        for c in s:
            self.p.send(c)
            time.sleep(delay)

    def respond(self, pat, s, timeout=-1):
        self.expect(pat, timeout)
        time.sleep(0.3)
        self.type(s)

    def boot(self):
        """Boot to a not-logged-in DDT with the date set."""
        self.respond('KLH10#', 'go\r')
        self.respond('DSKDMP', 'its\r')
        time.sleep(1)
        self.type(ESC + 'g')
        self.expect('IN OPERATION')
        time.sleep(2)
        self.type('\032')                      # ^Z: get a DDT
        self.respond('Fair', ':pdset\r')
        t = time.localtime()
        self.respond('PDSET', '%dC' % (t.tm_year // 100))
        self.type(time.strftime('%y%m%dD', t))
        self.type(time.strftime('%H%M%ST', t))
        self.type('!.')
        if self.expect(['DAYLIGHT SAVINGS TIME?', '\n']) == 0:
            self.type('Y' if t.tm_isdst > 0 else 'N')
            self.expect('\n')
        self.type('Q')
        self.expect(':KILL')

    def login(self, user='lisper'):
        time.sleep(1)
        self.type(':login %s\r' % user)
        time.sleep(3)

    def shutdown(self):
        """Clean ITS shutdown; assumes a logged-in DDT at top level."""
        self.type(':lock\r')
        self.respond('_', '5kill')
        self.respond('GO DOWN?', 'y')
        self.respond('BRIEF MESSAGE', '\003')
        self.respond('_', 'q')
        self.expect(':KILL')
        time.sleep(1)
        self.type(':logout\r')
        self.respond('SHUTDOWN COMPLETE', '\034', timeout=600)
        self.respond('KLH10>', 'quit\r')
        self.respond('Confirm', 'y\r')
        self.p.expect(pexpect.EOF)


if __name__ == '__main__':
    its = ITS(log=sys.stdout, reset='--reset' in sys.argv[1:])
    its.boot()
    its.p.logfile_read = None
    sys.stdout.write('\r\n\r\n[ITS is up and the date is set.  Type  :login yourname'
                     '  then  :lisp\r\n Ctrl-\\ gets the emulator prompt.]\r\n')
    sys.stdout.flush()
    its.p.interact(escape_character=None)
