#!/bin/bash
mkdir -p ~/.backup                      # for my vimrc

src_dir="`dirname \"$0\"`"              # relative path
src_dir="`( cd \"$src_dir\" && pwd )`"  # absolutized and normalized path

# link all my stuff
for file in `ls $src_dir`; do
    if [[ $file != "README.md" && $file != "init.sh" ]]; then
        ln -snf $src_dir/$file ~/.$file
    fi
done

# get the grml projects zshrc
wget --quiet -O ~/.zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

# make user check if everything is installed, protip: `dotfiles/init.sh`
if which apt-get &> /dev/null; then
    echo sudo apt-get install vim-nox tmux git zsh keychain gnupg-agent exuberant-ctags
fi
if which pacman &> /dev/null; then
    echo sudo pacman -S gvim tmux git zsh keychain gnupg ctags
fi
