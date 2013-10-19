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

Each subdirectory of this repo represents a collection of dotfiles
corresponding to a single application. The top-level install script invokes a
smaller install script within each of these directories that is responsible for
setting up that particular program. In general, each directory-level install
script 

1. Installs any necessary system packages (assumes you're using apt, sorry);
2. Clones any necessary git repositories; and
3. Symlinks the configuration files into their respective places.

Details about each module are below.

zsh
---

Relies on the wonderful oh-my-zsh
(https://github.com/robbyrussell/oh-my-zsh) for zsh setup. Installs zsh,
sets it to be your default shell, downloads oh-my-zsh, and symlinks the files
contained herein into .zshrc and .oh-my-zsh/custom.

vim
---

Relies on the wonderful vimifed (https://github.com/zaiste/vimified), which in
turn relies on the amazing vundle (https://github.com/gmarik/vundle), to manage
vim configuration. Clones vimified, symlinks in my own backup, swap, and undo
directories, as well as my own before, extra, and after.vimrc files, and then
runs BundleInstall.

git
---

Simply symlinks my .gitconfig into place, which relies on some pretty
awesome customizations and ease-of-use improvements. Thanks to 
https://github.com/riannucci for most of the contributions.

xmonad
------

Clones my own xmonad repo, symlinks the directory into place, and builds
the xmonad binary for use the next time the X session is restarted.

coming soon
-----------

I hope to include dotfiles for byobu/tmux/screen soon. Do you have ideas for
other good sets of configuration files to include? File a feature request!
