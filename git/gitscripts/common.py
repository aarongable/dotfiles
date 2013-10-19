# Monkeypatch IMapIterator so that Ctrl-C can kill everything properly.
# Derived from https://gist.github.com/aljungberg/626518
import multiprocessing.pool
from multiprocessing.pool import IMapIterator
def wrapper(func):
  def wrap(self, timeout=None):
    return func(self, timeout=timeout or 1e100)
  return wrap
IMapIterator.next = wrapper(IMapIterator.next)
IMapIterator.__next__ = IMapIterator.next

import contextlib
import functools
import signal
import subprocess
import sys
import tempfile
import threading
import binascii


hexlify = binascii.hexlify
unhexlify = binascii.unhexlify
pathlify = lambda s: '/'.join('%02x' % ord(b) for b in s)

VERBOSE = '--verbose' in sys.argv
if VERBOSE:
  sys.argv.remove('--verbose')

NO_BRANCH = ('* (no branch)', '* (detached from ')

# Exception classes used by this module.
class CalledProcessError(Exception):
  def __init__(self, returncode, cmd, output=None, out_err=None):
    super(CalledProcessError, self).__init__()
    self.returncode = returncode
    self.cmd = cmd
    self.output = output
    self.out_err = out_err

  def __str__(self):
    return (
        'Command "%s" returned non-zero exit status %d' %
        (self.cmd, self.returncode))


def memoize_deco(default=None):
  def memoize_(f):
    """Decorator to memoize a pure function taking 0 or more positional args."""
    cache = {}

    @functools.wraps(f)
    def inner(*args):
      ret = cache.get(args)
      if ret is None:
        if default and inner.default_enabled:
          ret = default()
          cache[args] = ret
        else:
          ret = f(*args)
          if ret is not None:
            cache[args] = ret
      return ret
    inner.cache = cache
    inner.default_enabled = False

    return inner
  return memoize_


def initer(orig, orig_args):
  signal.signal(signal.SIGINT, signal.SIG_IGN)
  if orig:
    orig(*orig_args)


@contextlib.contextmanager
def ScopedPool(*args, **kwargs):
  if kwargs.pop('kind', None) == 'threads':
    pool = multiprocessing.pool.ThreadPool(*args, **kwargs)
  else:
    orig, orig_args = kwargs.get('initializer'), kwargs.get('initargs', ())
    kwargs['initializer'] = initer
    kwargs['initargs'] = orig, orig_args
    pool = multiprocessing.pool.Pool(*args, **kwargs)

  try:
    yield pool
    pool.close()
  except:
    pool.terminate()
    raise
  finally:
    pool.join()


class StatusPrinter(object):
  """Threaded single-stat status message printer."""
  ENABLED = VERBOSE

  def __init__(self, fmt):
    """
    Create a StatusPrinter.

    Call .start() to get it going.

    Args:
      fmt - String format with a single '%d' where the counter value should go.
    """
    self.fmt = fmt
    self._count = 0
    self._dead = False
    self._dead_cond = threading.Condition()
    self._thread = threading.Thread(target=self._run)

  def _emit(self, s):
    if self.ENABLED:
      sys.stderr.write('\r'+s)
      sys.stderr.flush()

  def _run(self):
    with self._dead_cond:
      while not self._dead:
        self._emit(self.fmt % self._count)
        self._dead_cond.wait(.5)
      self._emit((self.fmt+'\n') % self._count)

  def inc(self, amount=1):
    self._count += amount

  def __enter__(self):
    self._thread.start()
    return self.inc

  def __exit__(self, _exc_type, _exc_value, _traceback):
    self._dead = True
    with self._dead_cond:
      self._dead_cond.notifyAll()
    self._thread.join()
    del self._thread


def parse_one_committish():
  if len(sys.argv) > 2:
    print >> sys.stderr, 'May only specify one <committish> at a time.'
    sys.exit(1)

  target = sys.argv[1] if len(sys.argv) > 1 else 'HEAD'

  try:
    return unhexlify(git_hash(target))
  except CalledProcessError:
    print >> sys.stderr, '%r does not seem to be a valid commitish.' % target
    sys.exit(1)


def check_output(*popenargs, **kwargs):
  kwargs.setdefault('stdout', subprocess.PIPE)
  kwargs.setdefault('stderr', subprocess.PIPE)
  indata = kwargs.pop('indata', None)
  if indata is not None:
    kwargs['stdin'] = subprocess.PIPE
  process = subprocess.Popen(*popenargs, **kwargs)
  output, out_err = process.communicate(indata)
  retcode = process.poll()
  if retcode:
    cmd = kwargs.get('args')
    if cmd is None:
      cmd = popenargs[0]
    raise CalledProcessError(retcode, cmd, output=output, out_err=out_err)
  return output


GIT_EXE = 'git.bat' if sys.platform.startswith('win') else 'git'

def run_git(*cmd, **kwargs):
  cmd = (GIT_EXE,) + cmd
  if VERBOSE:
    print cmd
  ret = check_output(cmd, **kwargs)
  ret = (ret or '').strip()
  return ret


def cat_blob(ref, f):
  subprocess.check_call(['git', 'cat-file', 'blob', ref], stdout=f)


def abbrev(ref):
  return run_git('rev-parse', '--abbrev-ref', ref)


def git_hash(reflike):
  return run_git('rev-parse', reflike)


def git_intern_f(f, kind='blob'):
  ret = run_git('hash-object', '-t', kind, '-w', '--stdin', stdin=f)
  f.close()
  return ret


def git_tree(treeish, recurse=False):
  ret = {}
  opts = ['ls-tree', '--full-tree']
  if recurse:
    opts += ['-r']
  opts.append(treeish)
  try:
    for line in run_git(*opts).splitlines():
      if not line:
        continue
      mode, typ, ref, name = line.split(None, 3)
      ret[name] = (mode, typ, ref)
  except CalledProcessError:
    return None
  return ret


def git_mktree(treedict):
  """
  Args:
    treedict - { name: (mode, type, ref) }
  """
  with tempfile.TemporaryFile() as f:
    for name, (mode, typ, ref) in treedict.iteritems():
      f.write('%s %s %s\t%s\0' % (mode, typ, ref, name))
    f.seek(0)
    return run_git('mktree', '-z', stdin=f)


def parents(ref):
  return run_git('rev-parse', '%s^@' % ref).splitlines()


def upstream(branch):
  try:
    return run_git('rev-parse', '--abbrev-ref', '--symbolic-full-name',
                   branch+'@{upstream}')
  except CalledProcessError:
    return None


def branches(*args):
  for line in run_git('branch', *args).splitlines():
    if line.startswith(NO_BRANCH):
      continue
    yield line.split()[-1]


def tags(*args):
  for line in run_git('tag', *args).splitlines():
    if line.startswith(NO_BRANCH):
      continue
    yield line.split()[-1]


def current_branch():
  return abbrev('HEAD')


def clean_refs():
  run_git('tag', '-d',
          *[t.strip() for t in run_git('tag', '-l', 'gitscripts.*').split()])


MERGE_BASE_TAG_FMT = "gitscripts.merge_base_for_%s"


def manual_merge_base_tag(branch, base):
  tag = "gitscripts.merge_base_for_%s" % git_hash(branch)
  run_git('tag', '-f', '-m', tag, tag, git_hash(base))


def nuke_merge_base_tag(branch):
  tag = "gitscripts.merge_base_for_%s" % git_hash(branch)
  run_git('tag', '-d', tag)


def get_or_create_merge_base_tag(branch, parent):
  tag = MERGE_BASE_TAG_FMT % git_hash(branch)
  tagval = None
  try:
    tagval = git_hash(tag)
    if VERBOSE:
      print 'Found tagged merge-base for %s: %s' % (branch, tagval)
  except CalledProcessError:
    pass
  if not tagval:
    run_git('tag', '-m', tag, tag, run_git('merge-base', parent, branch))
    tagval = git_hash(tag)
  return tagval+'^{}'  # this lets rev-parse know this is actually a tag
