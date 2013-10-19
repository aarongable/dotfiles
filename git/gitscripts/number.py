#!/usr/bin/env python

import collections
import os
import struct
import subprocess
import tempfile

from common import git_hash, run_git, git_intern_f, git_tree
from common import git_mktree, StatusPrinter, hexlify, unhexlify, pathlify
from common import parse_one_committish, ScopedPool, memoize_deco


CHUNK_FMT = '!20sL'
CHUNK_SIZE = struct.calcsize(CHUNK_FMT)
DIRTY_TREES = collections.defaultdict(int)
REF = 'refs/number/commits'
PREFIX_LEN = 1


def get_num_tree(prefix_bytes):
  """Return a dictionary of the blob contents specified by |prefix_bytes|.
  This is in the form of {<full ref>: <gen num> ...}

  >>> get_num_tree('\x83\xb4')
  {'\x83\xb4\xe3\xe4W\xf9J*\x8f/c\x16\xecD\xd1\x04\x8b\xa9qz': 169, ...}
  """
  ret = {}
  ref = '%s:%s' % (REF, pathlify(prefix_bytes))

  p = subprocess.Popen(['git', 'cat-file', 'blob', ref],
                        stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  p.stderr.close()
  raw = buffer(p.stdout.read())
  for i in xrange(len(raw) / CHUNK_SIZE):
    ref, num = struct.unpack_from(CHUNK_FMT, raw, i * CHUNK_SIZE)
    ret[ref] = num

  return ret


def intern_num_tree(tree):
  """Transform a number tree (in the form returned by |get_num_tree|) into a
  git blob.

  Returns the git blob hash.

  >>> d = {'\x83\xb4\xe3\xe4W\xf9J*\x8f/c\x16\xecD\xd1\x04\x8b\xa9qz': 169}
  >>> intern_num_tree(d)
  'c552317aa95ca8c3f6aae3357a4be299fbcb25ce'
  """
  with tempfile.TemporaryFile() as f:
    for k, v in sorted(tree.iteritems()):
      f.write(struct.pack(CHUNK_FMT, k, v))
    f.seek(0)
    return git_intern_f(f)


@memoize_deco()
def get_num(ref):
  """Takes a hash and returns the generation number for it or None."""
  return get_num_tree(ref[:PREFIX_LEN]).get(ref)


def set_num(ref, val):
  """Updates the global state such that the generation number for |ref|
  is |val|.

  This change will not be saved to the git repo until finalize() is called.
  """
  prefix = ref[:PREFIX_LEN]
  get_num_tree(prefix)[ref] = val
  DIRTY_TREES[prefix] += 1
  get_num.cache[ref,] = val
  return val


UPDATE_IDX_FMT = '100644 blob %s\t%s\0'
def leaf_map_fn(prefix_tree):
  pre, tree = prefix_tree
  return UPDATE_IDX_FMT % (intern_num_tree(tree), pathlify(pre))


def finalize(target):
  """After calculating the generation number for |target|, call finalize to
  save all our work to the git repository.
  """
  if not DIRTY_TREES:
    return

  msg = 'git-number Added %s numbers' % sum(DIRTY_TREES.itervalues())


  idx = os.path.join(run_git('rev-parse', '--git-dir'), 'number.idx')
  env = {'GIT_INDEX_FILE': idx}

  with StatusPrinter('Finalizing: (%%d/%d)' % len(DIRTY_TREES)) as inc:
    run_git('read-tree', REF, env=env)

    prefixes_trees = ((p, get_num_tree(p)) for p in sorted(DIRTY_TREES))
    updater = subprocess.Popen(['git', 'update-index', '-z', '--index-info'],
                               stdin=subprocess.PIPE, env=env)

    with ScopedPool() as leaf_pool:
      for item in leaf_pool.imap(leaf_map_fn, prefixes_trees):
        updater.stdin.write(item)
        inc()

    updater.stdin.close()
    updater.wait()

    run_git('update-ref', REF,
            run_git('commit-tree', '-m', msg,
                    '-p', git_hash(REF), '-p', target,
                    run_git('write-tree', env=env)))


def preload_tree(prefix):
  return prefix, get_num_tree(prefix)


def resolve(target):
  """Return the generation number for target.

  As a side effect, record any new calculated data to the git repository.
  """
  num = get_num(target)
  if num is not None:
    return num

  if git_tree(REF) is None:
    empty = git_mktree({})
    ref = run_git('commit-tree', '-m', 'Initial commit from git-number', empty)
    run_git('update-ref', REF, ref)

  with ScopedPool() as pool:
    available = pool.apply_async(git_tree, args=(REF,), kwds={'recurse': True})
    preload = set()
    rev_list = []

    with StatusPrinter('Loading commits: %d') as inc:
      for line in run_git('rev-list', '--topo-order', '--parents',
                         '--reverse', hexlify(target), '^'+REF).splitlines():
        toks = map(unhexlify, line.split())
        rev_list.append((toks[0], toks[1:]))
        preload.update(t[:PREFIX_LEN] for t in toks)
        inc()

    preload.intersection_update(
      unhexlify(k.replace('/', ''))
      for k in available.get().iterkeys()
    )
    preload.difference_update((x,) for x in get_num_tree.cache)

    if preload:
      preload_iter = pool.imap_unordered(preload_tree, preload)
      with StatusPrinter('Preloading nurbs: (%%d/%d)' % len(preload)) as inc:
        for prefix, tree in preload_iter:
          get_num_tree.cache[prefix,] = tree
          inc()

  get_num_tree.default_enabled = True


  for ref, pars in rev_list:
    num = set_num(ref, max(map(get_num, pars)) + 1 if pars else 0)

  finalize(hexlify(target))

  return num


def main():
  try:
    print resolve(parse_one_committish())
  except KeyboardInterrupt:
    pass


if __name__ == '__main__':
  main()
