# cd mods
cd() {
  builtin cd $1;
  ls;
}

source /usr/share/autojump/autojump.zsh

rdtun() {
  ssh agable@ssh.chromium.org -L3389:$1.golo.chromium.org:3389
}

rdspawn() {
  rdesktop localhost -u GOLO\\agable -p - -5 -K -r clipboard:CLIPBOARD
}
