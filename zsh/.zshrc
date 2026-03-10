#!/bin/zsh
# zsh interactive configuration
# last update: 2026-03-11

# History (interactive only)
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=$HOME/.zhistory
HISTFILESIZE=10000
export HISTSIZE SAVEHIST HISTFILE HISTFILESIZE

setopt append_history
setopt share_history
setopt hist_reduce_blanks
setopt hist_ignore_all_dups
setopt hist_ignore_space

# Basic shell options for interactive shells
setopt autocd extendedglob correct promptsubst auto_pushd \
  pushd_ignore_dups auto_remove_slash auto_param_keys interactive_comments \
  extended_history numeric_glob_sort complete_in_word completealiases no_beep list_packed cdablevars ignore_eof
unsetopt append_history PROMPT_CR

# Completion settings
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'

autoload run-help
bindkey -e

# Aliases
alias a=alias
a rm='rm -i'
a ls='/opt/homebrew/bin/gls --color -h --ignore=".DS_Store" --show-control-chars'
a g='dirs -v; echo -n "select number: "; read newdir; cd +"$newdir"'
a less='less -R'
alias code='open -a /Applications/Visual\ Studio\ Code.app'

# Abbreviations (keystroke expansion)
typeset -A myabbrev
myabbrev=(
  tx 'tar xvzf'
  tj 'tar xvjf'
  tc 'tar cvf'
  hl '|wc -l'
  dn '/dev/null'
)
my-expand-abbrev() {
  local left prefix
  left=$(echo -nE "$LBUFFER" | sed -e "s/[_a-zA-Z0-9:]*$//")
  prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^_a-zA-Z0-9:]\([_a-zA-Z0-9:]*\)$/\1/")
  LBUFFER=$left${myabbrev[$prefix]:-$prefix}" "
}
zle -N my-expand-abbrev
bindkey "^u" my-expand-abbrev

# Prompt (keep existing look-and-feel)
case $TERM in
  xterm|xterm-256color)
    PROMPT="%{\e[$[35]m%}%n%{\e[$[32]m%}@%m%{\e[00m%}%{\e[$[33]m%} $ %{\e[m%}"
    RPROMPT="%{\e[07m%}%{\e[$[31]m%}%~%{\e[m%}"
    ;;
  *)
    PROMPT="%m%~%# %"
    unset RPROMPT
    ;;
esac

# Homebrew environment (keeps PATH, etc.)
if command -v brew >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
export PATH="/opt/homebrew/opt/libtool/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"

# anyenv / pyenv
export PATH="$HOME/.anyenv/bin:$PATH"
if command -v anyenv >/dev/null 2>&1; then
  eval "$(anyenv init -)"
fi
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv init --path)"
fi

# Initialize completion system
autoload -U compinit
compinit -u

# SSH keychain (interactive)
if [ -x /opt/homebrew/bin/keychain ]; then
  export HOSTNAME=$(hostname)
  /opt/homebrew/bin/keychain ~/.ssh/id_ed25519_github
  [ -f ~/.keychain/${HOSTNAME}-sh ] && source ~/.keychain/${HOSTNAME}-sh >/dev/null 2>&1
fi

# Source local env helpers and tools
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# juliaup bin
path=("$HOME/.juliaup/bin" $path)
export PATH

# Helper functions
function cb() {
  local -r dir=$(bm search)
  if [ -z "$dir" ]; then
    return 1
  fi
  cd "$dir" || return 1
}

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
### End of Zinit's installer chunk
zinit light olets/zsh-abbr

# mise, broot, starship (interactive tools)
[ -x "$HOME/.local/bin/mise" ] && eval "$(${HOME}/.local/bin/mise activate zsh)"
[ -f "$HOME/.config/broot/launcher/bash/br" ] && source "$HOME/.config/broot/launcher/bash/br"
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
