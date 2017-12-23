#!/bin/bash
mkdir -p ~/.backup

dotfiles_dir="$( cd "$(dirname "$0")" && pwd )"

for pkg in dunst fish git i3 nvim screen termite tmux xorg zathura; do
    stow -d ${dotfiles_dir} -t ${HOME} -R ${pkg}
done;
