# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.local/share/fzf/bin* ]]; then
  export PATH="$PATH:$HOME/.local/share/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.local/share/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.local/share/fzf/shell/key-bindings.zsh"

