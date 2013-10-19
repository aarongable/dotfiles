#!/usr/bin/python
import sys

from pprint import pprint

from collections import namedtuple

from bclean import bclean
from squash import squash
from common import CalledProcessError, run_git, VERBOSE, upstream
from common import branches, current_branch, get_or_create_merge_base_tag
from common import clean_refs, git_hash

RebaseRet = namedtuple('TryRebaseRet', 'success message')

def rebase(parent, start, branch, abort=False):
  try:
    run_git('rebase', '--onto', parent, start, branch)
    return RebaseRet(True, '')
  except CalledProcessError as cpe:
    if abort:
      run_git('rebase', '--abort')
    return RebaseRet(False, cpe.output)


def clean_branch(branch, parent, starting_ref):
  if (git_hash(parent) != git_hash(starting_ref)
      and git_hash(branch) != git_hash(starting_ref)):
    print 'Rebasing:', branch

    # Try a plain rebase first
    if rebase(parent, starting_ref, branch, abort=True).success:
      return

    # Maybe squashing will help?
    print "Failed! Attempting to squash", branch, "...",
    squash_branch = branch+"_squash_attempt"
    run_git('checkout', '-b', squash_branch)
    squash()

    squash_ret = rebase(parent, starting_ref, squash_branch, abort=True)
    run_git('checkout', branch)
    run_git('branch', '-D', squash_branch)

    if squash_ret.success:
      print 'Success!'
      squash()
    final_rebase = rebase(parent, starting_ref, branch)
    assert final_rebase.success == squash_ret.success

    if not squash_ret.success:
      print squash_ret.message
      print 'Failure :('
      print 'Your working copy is in mid-rebase. Please completely resolve and'
      print 'run `git reup` again.'
      sys.exit(1)


def main():
  if '--clean' in sys.argv:
    clean_refs()
    return 0

  orig_branch = current_branch()
  if orig_branch == 'HEAD':
    orig_branch = git_hash('HEAD')

  if 'origin' in run_git('remote').splitlines():
    run_git('fetch', 'origin', stderr=None)
  else:
    run_git('svn', 'fetch', stderr=None)
  branch_tree = {}
  for branch in branches():
    parent = upstream(branch)
    if not parent:
      print 'Skipping %s: No upstream specified' % branch
      continue
    branch_tree[branch] = parent

  starting_refs = {}
  for branch, parent in branch_tree.iteritems():
    starting_refs[branch] = get_or_create_merge_base_tag(branch, parent)

  if VERBOSE:
    pprint(branch_tree)
    pprint(starting_refs)

  # XXX There is a more efficient way to do this, but for now...
  while branch_tree:
    this_pass = [i for i in branch_tree.items() if i[1] not in branch_tree]
    for branch, parent in this_pass:
      clean_branch(branch, parent, starting_refs[branch])
      del branch_tree[branch]

  clean_refs()

  bclean()

  if orig_branch in branches():
    run_git('checkout', orig_branch)
  else:
    run_git('checkout', 'origin/master')

  return 0


if __name__ == '__main__':
  sys.exit(main())
