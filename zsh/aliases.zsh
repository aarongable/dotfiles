# Quicker access to all the various ls modes
# nicer ls, all other alii reference this one
alias     ls='ls --color=auto -hF --group-directories-first'
# show all files
alias     la='ls -A'
# show all files, in a list
alias     ll='ls -lA'
# show all files sorted by date
alias     lt='ls -lAt'
# recursively list all files with full paths
alias     lr='ls -d -1 $PWD/**/*'

# Useful commands made better (according to some) through alias:
alias     mv='nocorrect mv'
alias     cp='nocorrect cp'
alias     rm='nocorrect rm'        # The nocorrect option keeps the zsh spell checker from
alias     mkdir='nocorrect mkdir'     # running on any of the arguments passed to the command.
alias     man='nocorrect man'
alias     ln='ln -r'  # Always do relative symlinks

alias     git='nocorrect git'
alias     rsync='rsync -vhuP'

# Open the named file in the current vscode window
alias     c='code -r'
alias     v='vim -O'

# start a new named tmux session
alias     ts='tmux -2 new-session -A -s'
# attach a new tmux session to the windows from the named one
alias     tt='tmux -2 new-session -t'
# list all currently running tmux sessions
alias     tls='tmux -2 list-sessions'

# ack-grep is a silly name
alias     ack=ack-grep

alias     btu='docker-compose run --use-aliases boulder ./test.sh --unit'
alias     bti='docker-compose run --use-aliases boulder ./test.sh --integration'
alias     btun='docker-compose -f docker-compose.yml -f docker-compose.next.yml run --use-aliases boulder ./test.sh --unit'
alias     btin='docker-compose -f docker-compose.yml -f docker-compose.next.yml run --use-aliases boulder ./test.sh --integration'
