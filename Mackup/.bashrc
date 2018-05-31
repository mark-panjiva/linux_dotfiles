source /etc/bash_completion.d/git  
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
# append to the history file, don't overwrite it
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# colors
RED="\[\033[31m\]"
GREEN="\[\033[32m\]"
YELLOW="\[\033[33m\]"
BLUE="\[\033[0;34m\]"
BLUE_B="\[\033[1;34m\]"
WHITE_B="\[\033[1;37m\]"
NO_COLOR="\[\033[0m\]"

# prompt with git repo
export PS1="\u@\h $BLUE\w $YELLOW\$(__git_ps1 "$(%s)")$NO_COLOR$BLUE_B 🐼 👊  $NO_COLOR";
export DEVSYNC_REMOTE="yellow.panjiva.com"

# aliases
alias ff="find . -type f -name "
alias gl="git log --pretty=format:'%C(green)%ad %C(auto)%h %C(auto)[%an]%C(auto)%d %s %C(auto)[%an]' --date=format:'%Y/%m/%d %H:%M'"
alias gs="git status --column"
alias gp="git push -u origin \$__git_ps1 "$(%s)""
alias gpf="git push -f -u origin \$__git_ps1 "$(%s)""
export RAILS_ENV=development_mark
alias dbm="RAILS_ENV=development_mark bundle exec rake db:migrate"
alias cg="cd ~/workspaces/web"
alias bi="rvmsudo bundle install"
alias tag-gen="cg;ctags -R --languages=ruby --exclude=.git --exclude=log . ;cd -" 
alias snap-gen="ssh deploy@lethe 'web/tools/snapshot_db_zfs -f mark'"
alias xclip="xclip -selection c"
export REPO_PATH=~/workspaces/web     # change for your layout
alias git_clean_local_branches='git branch --merged | egrep -v "(^\*|master)" | xargs --no-run-if-empty git branch -d'
alias git_clean_remote_branches='git branch -r --merged | egrep -v "(^\*|master)" | xargs --no-run-if-empty -n 1 git push --delete'
alias cat='pygmentize -g'
if [ -f $REPO_PATH/script/panjiva_bashrc ]; then
  source $REPO_PATH/script/panjiva_bashrc
  setup_git_hooks
fi
export TERM=xterm-256color
alias lastsnap='ssh deploy@yukon "salt -L 'lethe,arno' cmd.run '/home/deploy/scripts/most_recent_snapshot.sh' --out txt"'

export API_ACCESS_TOKEN="qUWznXxnHvZeizwZAhpU3Xp3IUtYkLuK5q47jgt8"
export RUBYOPT=-W0


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
