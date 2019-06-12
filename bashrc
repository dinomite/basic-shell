if ((BASH_VERSINFO[0] < 4))
then
  echo "Your bash version is out of date"
  echo "Install the latest bash with:"
  echo "    brew install bash"
  echo "    sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'"
  echo "    chsh -s /usr/local/bin/bash"
fi

# Update window size after every command
shopt -s checkwinsize

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

## SANE HISTORY DEFAULTS ##
# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Record each line as it gets issued
PROMPT_COMMAND='history -a'

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
HISTFILESIZE=100000

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '

## Homebrew installed things ##
if hash brew 2> /dev/null; then
    BREW_PREFIX=/usr/local
else
    echo "Couldn't find Homebrew installation"
fi
if [ -n "$BREW_PREFIX" ]; then
    if [ -f $BREW_PREFIX/etc/bash_completion ]; then
        . $BREW_PREFIX/etc/bash_completion
    else
        echo "Couldn't find Homebrew-installed bash-completion"
        echo "Install it with: brew install bash-completion"
    fi

    if [ -f $BREW_PREFIX/etc/profile.d/autojump.sh ]; then
        . $BREW_PREFIX/etc/profile.d/autojump.sh
    else
        echo "Couldn't find Homebrew-installed autojump"
        echo "Install it with: brew install autojump"
    fi
fi
