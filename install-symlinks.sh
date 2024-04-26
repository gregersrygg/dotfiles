#!/usr/bin/env bash

install_file() {
    # get absolute path to the current script
    script_dir=$(cd "$(dirname "$0")" && pwd)
    srcfile=$script_dir/$1
    dstfile=$2

    if [ -L $dstfile ]; then
        if [ $(readlink $dstfile) = $srcfile ]; then
            echo "Skipping already symlinked $dstfile"
            return
        else
            echo "Removing old symlink"
            rm $dstfile
        fi
        return
    fi

    if [ -f $dstfile ]; then
        echo "Backing up $dstfile to $dstfile.org"
        mv $dstfile $dstfile.org
    fi

    ln -s $srcfile $dstfile

}

create_file_if_not_exists() {
    if [ ! -f $1 ]; then
        touch $1
    fi
}

mkdir -p ~/.local/dotfiles

for file in .{aliases,completion,exports,functions,gitconfig,wtdotenv}; do
    install_file $file ~/$file
done;

# create empty files if they don't exist in ~/.local/dotfiles
for file in .{aliases,completion,exports,functions,wtdotenv,path,extra}; do
    create_file_if_not_exists ~/.local/dotfiles/$file
done;

# if .gitconfig does not exist in ~/.local/dotfiles, copy it from the repo
if [ ! -f ~/.local/dotfiles/.gitconfig ]; then
    cp .local/dotfiles/.gitconfig ~/.local/dotfiles/.gitconfig
fi

if echo "$SHELL" | grep -q "zsh"; then
    install_file .shellrc ~/.zshrc
elif echo "$SHELL" | grep -q "bash"; then
    install_file .shellrc ~/.bashrc
fi

install_file west-completion.sh ~/west-completion.sh

unset file;
