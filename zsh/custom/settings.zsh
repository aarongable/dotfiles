# Remember the last 5000 commands
HISTSIZE=10000
SAVEHIST=1000000
HISTFILE=$XDG_CACHE_HOME/zsh/history
setopt share_history

# Have zsh tell you when background jobs finish
setopt notify

# Turn off the infuriating beeping noises
# If you want the shell to beep when you make a mistake,
# comment this line out and run source .zshrc on it.
setopt nobeep

# Protect files from being overwritten
setopt noclobber

# Add a spell checking option for commands
setopt correct

# Include dotfiles when using <command> *
setopt glob_dots

# Disable core dumps
# (If you don't know what that is, you probably want it disabled.)
ulimit -c 0

# Load the zsh completion system
zstyle :compinstall file '/usr/local/google/home/agable/.zshrc'
autoload -U compinit
compinit

# Load zmv, which does programmable file renaming.
autoload -U zmv

# Use vim-style command editing and navigation
bindkey -v
# But fix backspacing over characters
bindkey '^?' backward-delete-char
# And allow use of arrow keys in !foo<tab> search
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

