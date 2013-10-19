#!/usr/bin/env python
import sys
import re

from common import current_branch, branches, run_git

def main(argv):
  assert 2 <= len(argv) < 3, "Must supply (<newname>) or (<oldname> <newname>)"
  if len(argv) == 2:
    old_name = current_branch()
    new_name = argv[1]
  else:
    old_name = argv[1]
    new_name = argv[2]
  assert old_name in branches(), "<oldname> must exist"
  assert new_name not in branches(), "<newname> must not exist"

  run_git('branch', '-m', old_name, new_name)

  matcher = re.compile(r'^branch\.(.*)\.merge$')
  branches_to_fix = []
  for line in run_git('config', '-l').splitlines():
    key, value = line.split('=', 1)
    if value == 'refs/heads/' + old_name:
      m = matcher.match(key)
      if m:
        branch = m.group(1)
        remote = run_git('config', '--get', 'branch.%s.remote' % branch)
        if remote == '.':
          branches_to_fix.append(branch)
  for b in branches_to_fix:
    run_git('config', 'branch.%s.merge' % b, 'refs/heads/' + new_name)


if __name__ == '__main__':
  sys.exit(main(sys.argv))


