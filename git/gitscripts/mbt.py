#!/usr/bin/env python
import sys

from common import nuke_merge_base_tag, manual_merge_base_tag
from common import CalledProcessError


def main(argv):
  assert len(argv) <= 2, "Must supply merge base or no arg."
  if len(argv) == 2:
    manual_merge_base_tag('HEAD', argv[1])
  else:
    try:
      nuke_merge_base_tag('HEAD')
    except CalledProcessError:
      print "No merge base tag currently exists for this branch."
  return 0


if __name__ == '__main__':
  sys.exit(main(sys.argv))

