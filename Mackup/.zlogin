

#
# User configuration sourced by login shells
#

# Initialize zim
[[ -s ${ZIM_HOME}/login_init.zsh ]] && source ${ZIM_HOME}/login_init.zsh

#
# User configuration sourced by login shells
#

# Executes commands at login post-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# Execute code only if STDERR is bound to a TTY.
[[ -o INTERACTIVE && -t 2 ]] && {

  # Print a random, hopefully interesting, adage.
  if (( $+commands[fortune] )); then
    fortune -s
    print
  fi

} >&2

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
