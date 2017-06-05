from __future__ import (absolute_import, division, print_function, unicode_literals)
import errno
import subprocess
import tempfile
import threading

subprocess_lock = threading.RLock()

def run_cmd(cmdline, env = None, shell = False):
    """
    Shamelessly stolen from my own repository (wizzat.py)
    Executes a command, returns the return code and the merged stdout/stderr contents.
    """
    global subprocess_lock
    try:
        fp = tempfile.TemporaryFile()
        with subprocess_lock:
            child = subprocess.Popen(cmdline,
                env     = env,
                shell   = shell,
                bufsize = 2,
                stdout  = fp,
                stderr  = fp,
            )

        return_code = child.wait()
        fp.seek(0, 0)
        output = fp.read()

        return return_code, output
    except OSError as e:
        if e.errno == errno.ENOENT:
            e.message += '\n' + ' '.join(cmdline)
        raise


def ack(term):
    cmd = "ack-grep -li '{}'".format(term)
    result, lines = run_cmd(cmd, shell=True)
    for x in lines.split('\n'):
        if x:
            yield x
