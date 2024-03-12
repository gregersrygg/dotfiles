#!/bin/zsh

for file in .{aliases,completion,exports,functions,gitconfig,zprofile,wtdotenv} west-completion.sh ; do
    if [ -f ~/$file ]; then
        echo "Backing up ~/$file to ~/$file.org"
        mv ~/$file ~/$file.org
    fi

    # get absolute path to the current script
    script_dir=$(cd "$(dirname "$0")" && pwd)

    ln -s $script_dir/$file ~/$file
done;
unset file;
