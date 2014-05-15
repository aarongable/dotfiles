# Rewrites nicknames and messages sent through comlink to be less annoying
# for IRC users.
#
# Author: Viraj Alankar <valankar@google.com>

use strict;
use Irssi;

sub clean_comlink {
  my ($server, $data, $nick, $mask, $target) = @_;

  if ($nick == "comlink") {
    if ($data =~ /^<(\w+)> (.*)/) {
      $nick = $1;
      $data = $2;
    }
  }
  Irssi::signal_continue($server, $data, $nick, $mask, $target);
}

Irssi::signal_add_first('message public', 'clean_comlink');
