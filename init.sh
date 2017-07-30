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
