#!/usr/bin/env python
import sys

from common import upstream, current_branch, branches, run_git
from common import get_or_create_merge_base_tag, VERBOSE

def main(argv):
  assert len(argv) == 2, "Must supply new parent"
  branch = current_branch()
  new_parent = argv[1]
  cur_parent = upstream(branch)
  assert branch != 'HEAD', 'Must be on the branch you want to reparent'
  assert cur_parent != new_parent

  get_or_create_merge_base_tag(branch, cur_parent)

  print "Reparenting %s to track %s (was %s)" % (branch, new_parent, cur_parent)
  run_git('branch', '--set-upstream-to', new_parent, branch)
  try:
    cmd = ['reup'] + (['--verbose'] if VERBOSE else [])
    run_git(*cmd, stdout=None, stderr=None)
  except:
    print "Resetting parent back to %s" % (cur_parent)
    run_git('branch', '--set-upstream-to', cur_parent, branch)
    raise

  return 0


if __name__ == '__main__':
  sys.exit(main(sys.argv))

