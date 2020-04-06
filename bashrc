#
# .bashrc for OS X and Arch Linux
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Helper functions
_exists () {
    hash "$1" 2>/dev/null
}

# Environment variables
# ----------------------------------------------------------
PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc

### bash history
### keep long history, append after each command
export HISTCONTROL=ignoredups:erasedups:ignoreboth
export HISTSIZE=1000000
export HISTFILESIZE=1000000
shopt -s histappend
shopt -s checkwinsize
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

### Global
export VISUAL=vim
export EDITOR=vim
export LANG=en_US.UTF-8

# coloured man pages
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# Bash config
# ----------------------------------------------------------

# Disable Ctrl-S (input stop), Ctrl-Q
stty -ixon


# OS X specific
# ----------------------------------------------------------

if [[ $PLATFORM == "Darwin" ]]; then

  function clip() {
    [ -t 0 ] && pbpaste || pbcopy;
  }

  ### Homebrew stuff
  export PATH="/usr/local/sbin:$PATH"
  export HOMEBREW_NO_ANALYTICS=1

  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi

# Linux
# ----------------------------------------------------------
if [[ $PLATFORM == "Linux" ]]; then

  # handy clip alias
  function clip() {
    [ -t 0 ] && xclip -selection clipboard -o || xclip -selection clipboard
  }

  # open files/protocols
  function open () {
    xdg-open "$*" > /dev/null 2>&1 &
  }

  brightness() {
    between_1_and_100='^[1-9][0-9]?$|^100$'
    percent=$*
    if ! [[ $percent =~ $between_1_and_100 ]]; then
      echo "error: Enter a number from 1 to 100"; return;
    fi
    max=`cat /sys/class/backlight/intel_backlight/max_brightness`
    let brightness="$max / 100 * $percent"
    echo "$brightness" | sudo tee /sys/class/backlight/intel_backlight/brightness > /dev/null
  }
fi

# local npm directory
PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules


# Aliases
# ----------------------------------------------------------

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias l='ls -CF'
alias ll='ls -l'
alias la='ls -A --group-directories-first'
alias lla='ls -lA'
alias which='type -p'
alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bashrc'
alias g='git'
alias grep='grep -n --color=auto'
alias ccat='bat'
alias brwe='brew'
alias bim='vim'
alias cim='vim'
alias fvim='vim `fzf`'
alias rtorrent='tmux attach-session -t rt || tmux new-session -s rt rtorrent'
alias trash='mv -t /tmp'
alias pc='pass -c'

if _exists nvim ; then
  alias vim='nvim'
fi

if _exists colordiff ; then
  alias diff='colordiff -u'
fi

# make directory and cd to it
mkcd() {
  mkdir -p -- "$1" &&
    cd -P -- "$1"
}


### add bash completion on on aliases

GIT_COMPLETION='/usr/share/bash-completion/completions/git'
if [ -f $GIT_COMPLETION ]; then
  source $GIT_COMPLETION
  complete -o default -o nospace -F _git g
fi
unset GIT_COMPLETION

PASS_COMPLETION='/usr/share/bash-completion/completions/pass'
if [ -f $PASS_COMPLETION ]; then
  source $PASS_COMPLETION
  complete -o filenames -o nospace -F _pass pc
fi
unset PASS_COMPLETION


### Colored ls
if _exists dircolors ; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
elif [ "$PLATFORM" = "Darwin" ]; then
  alias ls='ls -G'
  alias la='ls -A'
fi


### Awesome prompt, generated by promptline.vim
if [ -f ~/.goodies/promptline/shell_prompt.sh ]; then
  . ~/.goodies/promptline/shell_prompt.sh
fi

if [ -d ~/.dotfiles/thinkpad/ ] && \
   [ "`cat /sys/devices/virtual/dmi/id/product_version 2>/dev/null`" == "ThinkPad T420" ]
then
  export PATH=$PATH:~/.dotfiles/thinkpad
fi


if [ -d ~/.vim/plugged/gruvbox ]; then
  if [ "$PLATFORM" = "Darwin" ]; then
    source ~/.vim/plugged/gruvbox/gruvbox_256palette_osx.sh
  else
    source ~/.vim/plugged/gruvbox/gruvbox_256palette.sh
  fi
fi


###
if [ -f $HOME/.pythonrc ]; then
  export PYTHONSTARTUP=$HOME/.pythonrc
fi

# set PATH so it includes user's private ~/.local/bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

function count() {
  if [ "$1" ]; then
    find . -maxdepth 1 -name "*$1*" | wc -l;
  else
    echo "usage: count [pattern]";
  fi
}

# extract function for common file formats
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    return 1
 else
    if [ -f "$1" ] ; then
        case "${1,,}" in
          *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                       tar xvf "$1"       ;;
          *.lzma)      unlzma ./"$1"      ;;
          *.bz2)       bunzip2 ./"$1"     ;;
          *.rar)       unrar x -ad ./"$1" ;;
          *.gz)        gunzip ./"$1"      ;;
          *.zip)       unzip ./"$1"       ;;
          *.z)         uncompress ./"$1"  ;;
          *.7z)        7z x ./"$1"        ;;
          *.xz)        unxz ./"$1"        ;;
          *.exe)       cabextract ./"$1"  ;;
          *)
                       echo "extract: '$1' - unknown archive method"
                       return 1
                       ;;
        esac
    else
        echo "'$1' - file does not exist"
        return 1
    fi
fi
}

unset PLATFORM
