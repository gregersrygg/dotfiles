#!/bin/sh

install_file() {
    srcfile=$1
    dstfile=$2

    if [ -L $dstfile ]; then
        echo "Skipping already symlinked $dstfile"
        continue
    fi

    if [ -f $dstfile ]; then
        echo "Backing up $dstfile to $dstfile.org"
        mv $dstfile $dstfile.org
    fi

    # get absolute path to the current script
    script_dir=$(cd "$(dirname "$0")" && pwd)

    ln -s $script_dir/$srcfile $dstfile

}

for file in .{aliases,completion,exports,functions,gitconfig,zprofile,zshrc,wtdotenv}; do
    dstfile=$file
    # if file is .zshrc and we are in bash change it to .bashrc
    if [ $file == ".zshrc" ] && [ -n $BASH_VERSION ]; then
        dstfile=".bashrc"
    fi

    install_file $file ~/$dstfile
done;

install_file west-completion.sh ~/west-completion.sh

# install platform specific gitconfig
if [[ $(uname) == "Darwin" ]]; then
    install_file .gitconfig.macos ~/.gitconfig.platform
elif [[ $(uname) == "Linux" ]]; then
    install_file .gitconfig.linux ~/.gitconfig.platform
elif [[ $(uname) == "Windows" ]]; then
    install_file .gitconfig.windows ~/.gitconfig.platform
fi

unset file;
