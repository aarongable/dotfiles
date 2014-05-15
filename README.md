dotfiles
========

Setting up a new computer sucks. Especially when you've spent all that time and
energy getting the old one to behave *just* like you wanted. Well, no more.
This repo is my way of keeping track of all my various dotfiles and
configuration, so that I can easily clone, install, and be done with it.


setup
=====

Installation is very simple.

    git clone https://github.com/aarongable/dotfiles.git
    ./dotfiles/install.sh

Or, if you really trust me:

    curl -L https://raw.github.com/aarongable/dotfiles/master/install.sh | sh


modules
=======

Each subdirectory of this repo represents a collection of dotfiles corresponding
to a single application. The top-level install script invokes a smaller install
script within each of these directories that is responsible for setting up that
particular program. In general, each directory-level install script

1. Installs any necessary system packages (assumes you're using apt, sorry);
2. Clones any necessary git repositories; and
3. Symlinks the configuration files into their respective places.

Details about each module are in alphabetical order below.

git
---

Simply symlinks my .gitconfig into place, which relies on some pretty awesome
customizations and ease-of-use improvements. Thanks to [riannucci][] for most of
the contributions.

[riannucci]: https://github.com/riannucci/vimified

irssi
-----

Contains simple configuration for my irssi setup. This is probably the least
relevant portion of my setup to other people -- it contains configuration
stating which networks and channels I care about, and what username I use on
them -- but it is still a good template for others to use.

misc
----

This hold random configuration that doesn't belong anywhere else. Currently,
it just ensures that F10 doesn't get stolen by Gnome, so that it can be passed
through to tmux and other termincal applications.

tmux
----

A generally simple tmux configuration that takes advantage of [tmux-powerline][]
to have a pretty statusbar. In conjunction with vim, also configures powerful
shortcuts that allow seamless movement between vim splits and tmux panes.

[tmux-powerline]: https://github.com/erikw/tmux-powerline

vim
---

Relies on the wonderful [vimified][], which in turn relies on [vundle][], to
manage vim configuration. Clones vimified, creates backup, swap, and undo
directories, symlinks in my own before, extra, and after.vimrc files, and then
runs BundleInstall.

[vimified]: https://github.com/zaiste/vimified
[vundle]: https://github.com/gmarik/vundle

xmonad
------

Installs all of the dependencies of my xmonad system, including old-style gnome
and the Haskell compiler. Then symlinks the xmonad haskell configuration file
into place and builds the xmonad binary for use the next time the X session is
restarted.

zsh
---

Relies on the wonderful [oh-my-zsh][] for zsh setup. Installs zsh, sets it to be
your default shell, downloads oh-my-zsh, and symlinks the files contained herein
into .zshrc and .oh-my-zsh/custom.

[oh-my-zsh]: https://github.com/robbyrussell/oh-my-zsh
