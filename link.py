#!/usr/bin/env python

"""
Link everything in the subdirectory `dotfiles` into the home directory. The
target of every top-level file/directory should be prepended with a `.`;
everything else should keep its name as-is.
"""

import os


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
                os.symlink(src, dst)

