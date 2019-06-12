#!/usr/bin/env bash -ex

mv ~/.bashrc{,.bak}; cp {,~/.}bashrc
mv ~/.bash_profile{,.bak}; cp {,~/.}bash_profile
mv ~/.gitconfig{,.bak}; cp {,~/.}gitconfig
