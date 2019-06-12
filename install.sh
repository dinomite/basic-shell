#!/usr/bin/env bash -e
FILES=( "bashrc" "bash_profile" "gitconfig" )

# Prevent overwriting of files if backups already exist
for file in "${FILES[@]}"
do
    if [ -e ~/.$file.bak ]
    then
        echo "$file.bak already exists; refusing to overwrite it"
        exit 1
    fi
done

for file in "${FILES[@]}"
do
    mv ~/.$file{,.bak}
    cp {,~/.}$file
done
