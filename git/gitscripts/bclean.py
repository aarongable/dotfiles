import collections

from common import run_git, VERBOSE, CalledProcessError, upstream
from common import branches, current_branch

def bclean():
  merged = list(branches('--merged', 'origin/master'))

  if VERBOSE:
    print merged

  upstreams = {}
  downstreams = collections.defaultdict(list)
  for branch in branches():
    try:
      parent = upstream(branch)
      upstreams[branch] = parent
      downstreams[parent].append(branch)
    except CalledProcessError:
      pass

  if VERBOSE:
    print upstreams
    print downstreams

  if current_branch() in merged:
    run_git('checkout', 'origin/master')
  for branch in merged:
    for down in downstreams[branch]:
      if down not in merged:
        run_git('branch', '--set-upstream-to', upstreams[branch], down)
        print ('Reparented %s to track %s (was tracking %s)'
               % (down, upstreams[branch], branch))
    print run_git('branch', '-d', branch)

  return 0
