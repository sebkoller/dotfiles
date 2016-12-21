#
# .bashrc for OS X and Arch Linux
#

# Helper functions
_exists () {
    hash "$1" 2>/dev/null
}

# Environment variables
# ----------------------------------------------------------
export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc

### bash history
### keep long history, append after each command
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=1000000
export HISTFILESIZE=1000000
shopt -s histappend
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

### vim all the way
set -o vi
bind 'set completion-ignore-case on'


# OS X specific
# ----------------------------------------------------------

if [[ $PLATFORM == "Darwin" ]]; then

  function clip()
  {
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
  function clip()
  {
    [ -t 0 ] && xclip -selection clipboard -o || xclip -selection clipboard
  }

  # open files/protocols
  function open () {
    xdg-open "$*" > /dev/null 2>&1 &
  }

  brightness() {
	  max=`cat /sys/class/backlight/intel_backlight/max_brightness`
	  percent=$*
	  let brightness="$max / 100 * $percent"
	  echo "$brightness" | sudo tee /sys/class/backlight/intel_backlight/brightness > /dev/null
  }
fi


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
alias git-append='git commit --amend --no-edit'
alias gitp='git add -p'
alias g='git'
alias grep='grep -n --color=auto'
alias ccat='pygmentize -g'
alias brwe='brew'

if _exists colordiff ; then
  alias diff='colordiff -u'
fi

# bash completion on git alias
GIT_COMPLETION='/usr/share/bash-completion/completions/git'
if [ -f $GIT_COMPLETION ]; then
  source $GIT_COMPLETION
  complete -o default -o nospace -F _git g
fi


### Colored ls
if _exists dircolors ; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
elif [ "$PLATFORM" = "Darwin" ]; then
  alias ls='ls -G'
  alias la='ls -A'
fi


if [ "$TERM" = "xterm" ]; then
  export TERM=xterm-256color
fi

### Awesome prompt, generated by promptline.vim
if [ -f ~/.goodies/promptline/shell_prompt.sh ]; then
	. ~/.goodies/promptline/shell_prompt.sh
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

if [ -f $HOME/code/dwdeploy/dw_lib.sh ]; then
	source $HOME/code/dwdeploy/dw_lib.sh
fi


function count()
{
  if [ "$1" ]; then
    find . -maxdepth 1 -name "*$1*" | wc -l;
  else
    echo "usage: count [pattern]";
  fi
}

# function Extract for common file formats
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
