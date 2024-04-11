#!/bin/sh

for file in .{aliases,completion,exports,functions,gitconfig,zprofile,zshrc,wtdotenv} west-completion.sh ; do
    dstfile=$file
    # if file is .zshrc and we are in bash change it to .bashrc
    if [ $file == ".zshrc" ] && [ -n $BASH_VERSION ]; then
        dstfile=".bashrc"
    fi

    if [ -L ~/$dstfile ]; then
        echo "Skipping already symlinked ~/$dstfile"
        continue
    fi

    if [ -f ~/$dstfile ]; then
        echo "Backing up ~/$dstfile to ~/$dstfile.org"
        mv ~/$dstfile ~/$dstfile.org
    fi

    # get absolute path to the current script
    script_dir=$(cd "$(dirname "$0")" && pwd)

    ln -s $script_dir/$file ~/$dstfile
done;
unset file;
