#
# ALIASES
# 

alias  ls='ls -F'
alias  ll='ls -laF'
alias  la='ls -aF'

# Useful commands made better (according to some) through alias:
alias  mv='nocorrect mv -i'
alias  cp='nocorrect cp -i'
alias  rm='nocorrect rm -i'
alias  mkdir='nocorrect mkdir'
alias  man='nocorrect man'

cd() {
  builtin cd "$@";
  ls; 
}
