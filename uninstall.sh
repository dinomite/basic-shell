#!/usr/bin/env bash -e
FILES=( "bashrc" "bash_profile" "gitconfig" )

for file in "${FILES[@]}"
do
    mv ~/.$file{.bak,}
done
