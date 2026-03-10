#!/bin/zsh
# zsh configuration File: environment variables
# Last update: 2026-03-11

setopt all_export

# Minimal PATH for all shells (non-interactive too)
PATH="$HOME/local/bin:/opt/homebrew/bin:/bin:/usr/bin:/usr/X11R6/bin:/sbin:/usr/sbin"

# Manpath
MANPATH=/usr/share/man
MANPATH="$MANPATH:/usr/X11R6/man"

# Libraries
LD_LIBRARY_PATH=/usr/lib

# Locale
TERM="xterm-256color"
if [ "$TERM" = "kterm" ]; then
  LANG="ja_JP.EUC"
else
  LANG="ja_JP.UTF-8"
  LV='-z -Ou8'
fi
LC_COLLATE=C
LC_TIME=C

# Basic tools
DIRSTACKSIZE=20
PAGER=less
EDITOR=/usr/bin/vim
READNULLCMD=/opt/homebrew/bin/lv

# TeX/Bib inputs
TEXINPUTS=".:$HOME/Library/Personal/texmf//:"
BIBINPUTS=".:$HOME/Library/Personal/bibtex/bib"
BSTINPUTS=".:$HOME/Library/Personal/bibtex/bst"

# Remote tools
CVS_RSH='/usr/bin/ssh'
RSYNC_RSH='/usr/bin/ssh'
PERL_BADLANG=0

# Python helper path
PYTHON_PATH=${HOME}/local/lib/python:$PATH

WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"

unset LD_PREBIND

# Load cargo environment if present (keeps non-interactive shells functional)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
