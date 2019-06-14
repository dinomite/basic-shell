# basic-shell

First, install up-to-date Bash via Homewbrew and use it as your shell:

    brew install bash bash-completion autojump
    sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
    chsh -s /usr/local/bin/bash

Then, install the shell configs from this repository:

    git clone git@github.com:dinomite/basic-shell.git
    cd basic-shell
    ./install.sh

Start a new terminal to begin using this newly configured bash experience.  You'll need to update your name & email at the top of your `~/.gitconfig`.
