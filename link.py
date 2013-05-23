#!/usr/bin/env python

"""
Link everything in the subdirectory `dotfiles` into the home directory. The
target of every top-level file/directory should be prepended with a `.`;
everything else should keep its name as-is.
"""

import os
import errno


def mkdir_p(dirname):
    """
    Run the equivalent of the shell command `mkdir -p dirname`, where we ignore
    any errors that are raised if the directories exist.
    """
    try:
        os.makedirs(dirname)
    except OSError as err:
        if err.errno == errno.EEXIST and os.path.isdir(dirname):
            pass
        else: raise


if __name__ == '__main__':
    dotfiles = 'dotfiles'
    k = len(dotfiles) + len(os.sep)
    for dirpath, dirnames, filenames in os.walk(dotfiles):
        for filename in filenames:
            src = os.path.join(dirpath, filename)
            dst = os.path.expanduser(os.path.join('~', '.' + src[k:]))
            src = os.path.abspath(src)
            if os.path.lexists(dst):
                if os.path.samefile(src, dst):
                    continue
                else:
                    print "File '%s' exists but is not link" % dst
                    continue
            else:
                print "Creating file '%s'" % dst
                mkdir_p(os.path.dirname(dst))
                os.symlink(src, dst)

