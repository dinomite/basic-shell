if ((BASH_VERSINFO[0] < 4))
then
  echo "Your bash version is out of date"
  echo "Install the latest bash with:"
  echo "    brew install bash"
  echo "    sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'"
  echo "    chsh -s /usr/local/bin/bash"
fi

##### Prompt #####
GIT_PS1_SHOWCOLORHINTS=true
# staged '+', unstaged '*'
GIT_PS1_SHOWDIRTYSTATE=true
# '%' untracked files
GIT_PS1_SHOWUNTRACKEDFILES=true
# '<' behind, '>' ahead, '<>' diverged, '=' no difference
GIT_PS1_SHOWUPSTREAM="auto"
# '$' something is stashed
GIT_PS1_SHOWSTASHSTATE=true

function build_prompt {
    EXITSTATUS="$?"

    PROMPT="\[\e[90m\]\t\[\e[0m\] \[\033[33m\]\w\[\033[00m\] $(__git_ps1 "(%s)")\[\033[01;33m\]\$\[\033[00m\] "

    # Red background if the last command was unhappy
    if [ "${EXITSTATUS}" -eq 0 ]
    then
       PS1="${PROMPT}"
    else
       PS1="\[\033[41m\]${PROMPT}"
    fi

    # Change the titlebar in xterms
    echo -ne "\033]0;${PWD}\007"

    # Show command in screen
    echo -ne "\033k\033\0134"

    # Write history after every command
    history -a
}
PROMPT_COMMAND=build_prompt

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# Update window size after every command
shopt -s checkwinsize

##### History #####
# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

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

##### Homebrew installed things #####
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

##### Aliases #####
# Make colored 'ls' output legible
export LSCOLORS=ExFxCxDxBxegedabagacad
alias ls="ls -G"
alias sl="ls"
alias l="ls"
alias s="ls"
alias ll="ls -l"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."

alias grep='grep --color=auto'

### Git
function g {
    if [[ $# > 0 ]]; then
        git $@
    else
        git st
    fi
}
alias gti='git'
alias gitl='git l -n3'
alias gitb='git branch'
alias gitd='git diff'
alias master="git checkout master"
alias amd="git commit -a --amend --no-edit"
alias yoink='git stash && git pull && git stash pop'
alias yolo='git push -f'

### Maven
alias mci='mvn clean install'
alias mcit='mci -DskipTests'
alias mcp='mvn clean package'
alias mcpt='mcp -DskipTests'
alias mct="mvn clean test"

### Gradle
alias gr="./gradlew"
alias gw="./gradlew"
alias gcb="./gradlew clean build"

### Docker
alias dk=docker
alias dkc=docker-compose
alias dcu='docker-compose up'
alias dcb='docker-compose build base'
# Show all running containers
alias dps='docker ps --format "table {{.ID}}\t{{.CreatedAt}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}"'
# Stop all containers
alias dsa='docker stop $(docker ps -q)'
# Remove all containers
alias drm='docker rm $(docker ps --filter 'status=exited' --format '{{.ID}}' | xargs)'
# Remove all images
alias drmi='docker rmi $(docker images | grep ^classpass | tr -s " " | cut -f 3 -d " " | xargs)'
# Remove everything Docker knows about
alias docker-smash='dsa; docker rm $(docker ps -a -q); docker system prune -a; docker volume rm $(docker volume ls -q)'

### Python
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export WORKON_HOME=~/.venvs
mkdir -p $WORKON_HOME
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy
function enter-the-python {
        NAME=$(basename `pwd`)

    # If the project specifies a version but it's not installed, install that version
    pyenv version > /dev/null
    if [[ $? -ne 0 ]]; then
        if [[ -f .python-version ]]; then
            VERSION=$(cat .python-version)
            echo "Installing Python $VERSION"

            pyenv install "$VERSION"
        else
            echo "Don't know what Python version to install (no .python-version file)"
            echo "See output of `pyenv version` for details"
        fi
    fi

    workon "$NAME" 2> /dev/null
    if [[ $? -ne 0 ]]; then
        # If there isn't a virtualenv setup for the project create it
        echo "Creating virtualenv for $NAME"

        mkvirtualenv "$NAME"
        workon "$NAME"

        # And install any necessary dependencies
        if [[ -f "setup.py" ]]; then
            pip install -e .
        elif [[ -f "requirements.txt" ]]; then
            pip install -r requirements.txt
        fi
    fi
}

### ClassPass deployment
alias deploy-dev='cp_tools deploy_development update_service'
alias deploy-prod='cp_tools deploy_production update_service'
alias info-dev='cp_tools deploy_development service_info -h'
alias info-prod='cp_tools deploy_production service_info -h'
