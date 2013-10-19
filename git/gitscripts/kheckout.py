#!/usr/bin/env python

import multiprocessing
import os
import pygit2
import shutil
import sys

from common import parse_one_committish, hexlify, ScopedPool, git_tree
from common import run_git, CalledProcessError, StatusPrinter


FMT = "Checked out %%d/%d files"
PROC_COUNT = multiprocessing.cpu_count()
FLAGS = os.O_WRONLY | os.O_CREAT | os.O_TRUNC
if sys.platform.startswith('win'):
  FLAGS |= os.O_BINARY
REPO = None
TREE_ROOT = None


def init_repo():
  global REPO, TREE_ROOT
  if not REPO:
    git_dir = run_git('rev-parse', '--git-dir')
    REPO = pygit2.Repository(git_dir)
    TREE_ROOT = REPO.revparse_single('HEAD').tree


def mode_hex(path):
  try:
    cur = TREE_ROOT
    toks = path.split(os.sep)
    for tok in toks[:-1]:
      ent = cur[tok]
      cur = REPO[ent.oid]
    ent = cur[toks[-1]]
    return ent.filemode, ent.hex
  except Exception:
    return None, None


def place_file(path, mode, ref):
  try:
    fd = os.open(path, FLAGS, mode)
    d = REPO[ref].data
    os.write(fd, d)
    os.close(fd)
    os.chmod(path, mode)
  except Exception as e:
    print e


def place_link(path, ref):
  if os.path.exists(path):
    os.unlink(path)
  os.symlink(REPO[ref].data, path)


def make_dir(path):
  if not os.path.exists(path):
    os.makedirs(path)


def fix_head(target):
  try:
    git_dir = run_git('rev-parse', '--git-dir')
    with open(os.path.join(git_dir, 'HEAD'), 'wb') as f:
      f.write(target)
  except CalledProcessError as e:
    print e, e.out_err


def handle_file_lookup(path):
  handle_file(path, *mode_hex(path))


def handle_file(path, filemode, ref):
  if ref is None:
    kill_it(path)
  else:
    mode_hi = filemode >> (3*3)
    mode_lo = filemode & 0777
    if mode_hi == 0100:  # blob
      place_file(path, mode_lo, ref)
    elif mode_hi == 0120:  # link
      place_link(path, ref)
    elif mode_hi == 0160:  # commit
      make_dir(path)
    else:
      print 'I do not understand "%s": %o, %s' % (path, filemode, ref)
      assert False


def handle_dir(made_dirs, path):
  d = os.path.dirname(path)
  if d and d not in made_dirs:
    make_dir(d)
    made_dirs.add(d)


def nuke_extras(all_files):
  for dirpath, dirnames, filenames in os.walk('.'):
    if dirpath.endswith('.git'):
      dirnames[:] = []
      continue
    elif dirpath != '' and '.git' in dirnames:
      dirnames[:] = []
      continue

    for path in (os.path.join(dirpath, f) for f in filenames):
      if path not in all_files:
        os.unlink(path)


def force_checkout(tree):
  made_dirs = set()
  fmt = FMT % (len(tree) + 1)
  with StatusPrinter(fmt) as inc:
    ign_inc = lambda *_: inc()
    with ScopedPool(PROC_COUNT, initializer=init_repo) as pool:
      pool.apply_async(nuke_extras, (tree,), callback=ign_inc)

      for path, (mode, _, ref) in tree.iteritems():
        handle_dir(made_dirs, path)
        pool.apply_async(handle_file, (path, int(mode, 8), ref),
                         callback=ign_inc)


def kill_it(path):
  if os.path.exists(path):
    if os.path.isdir(path):
      shutil.rmtree(path)
    else:
      os.unlink(path)


def fancy_checkout():
  made_dirs = set()

  # Curiously, this is faster than REPO.status(), even on *nix.
  opts = ['--porcelain', '-z', '--ignore-submodules=dirty']
  f_diff = run_git('status', *opts).split('\0')

  total = (len(f_diff) - 1)
  fmt = FMT % total
  if not total:
    return

  with StatusPrinter(fmt) as inc:
    ign_inc = lambda *_: inc()
    with ScopedPool(PROC_COUNT, initializer=init_repo) as pool:
      for mode, path in (x.split(None, 1) for x in f_diff if x):
        # technically, path could be 'from\0to', but that only happens for
        # rename and copy status we don't support.
        if mode[0] in 'DMA?':
          handle_dir(made_dirs, path)
          pool.apply_async(handle_file_lookup, (path,), callback=ign_inc)
        else:
          print ("Got unexpected mode: %s %s" % (mode, path))
          assert False


def main():
  force = '-f' in sys.argv
  if force:
    sys.argv.remove('-f')

  StatusPrinter.ENABLED = True

  target = hexlify(parse_one_committish())
  print 'Got Target: %s' % target
  fix_head(target)
  run_git('reset', '-q', target)

  if force:
    force_checkout(git_tree(target, recurse=True))
  else:
    fancy_checkout()


if __name__ == '__main__':
  sys.exit(main())
