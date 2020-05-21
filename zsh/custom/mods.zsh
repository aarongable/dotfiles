# cd mods
cd() {
  builtin cd $1;
  ls;
}

source /usr/share/autojump/autojump.zsh
