#!/usr/bin/env python

"""
Link all configuration files into place.
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


def link(srcdir, dstdir, dotted=False, verbose=False):
    """
    Link all files from `srcdir` into `dstdir`. If `dotted` is True then prepend
    the top-level file or directory with a '.'.
    """
    k = len(srcdir) + len(os.sep)
    for dirpath, dirnames, filenames in os.walk(srcdir):
        for filename in filenames:
            src = os.path.join(dirpath, filename)
            if verbose:
                print "Processing file '%s'" % src
            dst = os.path.expanduser(os.path.join(dstdir, ('.' if dotted else '') + src[k:]))
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


if __name__ == '__main__':
    link('dotfiles', '~', dotted=True)
    link('sublime', '~/Library/Application Support/Sublime Text 3/Packages/User')

