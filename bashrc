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

##### Sane history defaults #####
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
alias ls="ls -F"
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
alias ugh='[ -d .venv ] || virtualenv .venv; . .venv/bin/activate'

### ClassPass deployment
alias deploy-dev='cp_tools deploy_development update_service'
alias deploy-prod='cp_tools deploy_production update_service'
alias info-dev='cp_tools deploy_development service_info -h'
alias info-prod='cp_tools deploy_production service_info -h'
