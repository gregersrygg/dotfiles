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
            echo "Removing old symlink $dstfile"
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

install_local_file() {
    file=$1

    if [ -f ~/.local/dotfiles/$file ]; then
        return
    fi

    if [ -f .local/dotfiles/$file ]; then
        cp .local/dotfiles/$file ~/.local/dotfiles/$file
    else
        touch $1
    fi
}

for file in .{aliases,completion,exports,functions,gitconfig,wtenvrc}; do
    install_file $file ~/$file
done;

mkdir -p ~/.local/dotfiles
for file in .{aliases,completion,exports,functions,gitconfig,wtenvrc,path,extra}; do
    install_local_file $file
done;

# .wtdotenv was replaced by .wtenvrc when switching from dotenv to direnv
for stale in ~/.wtdotenv ~/.local/dotfiles/.wtdotenv; do
    if [ -L $stale ] && [ ! -e $stale ]; then
        echo "Removing stale symlink $stale"
        rm $stale
    fi
done;
unset stale;

if echo "$SHELL" | grep -q "zsh"; then
    install_file .shellrc ~/.zshrc
elif echo "$SHELL" | grep -q "bash"; then
    install_file .shellrc ~/.bashrc
fi

install_file west-completion.sh ~/west-completion.sh

# build customized zephyr docker image used for running twister tests in native_sim
if command -v docker &> /dev/null; then
    docker build -t dotfiles .
fi

if ! command -v direnv &> /dev/null; then
    echo "WARNING: direnv not found. Worktree environments won't load automatically."
    echo "         Install it with 'brew install direnv' (or your package manager)."
fi

unset file;
