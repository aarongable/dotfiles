#!/usr/bin/env python
import sys

from common import current_branch, upstream, get_or_create_merge_base_tag
from common import run_git, clean_refs


def squash():
  branch = current_branch()
  parent = upstream(branch)
  merge_base = get_or_create_merge_base_tag(branch, parent)
  run_git('reset', '--soft', merge_base)
  run_git('commit', '-a', '-C', 'HEAD@{1}')

def main():
  squash()
  clean_refs()
  return 0

if __name__ == '__main__':
  sys.exit(squash())

