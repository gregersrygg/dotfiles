# Gregers's dotfiles

Here are my dotfiles that I mainly use to develop with Zephyr for Nordic Semiconductor.
I put them here for backup and in case someone else find them useful.

## Made for re-usability and local customizations

The dotfiles are organized in a way that makes it easier to share the configuraiton with others, and others can modify locally what they want to change/override without having to modify the original files.

### .shellrc

This is the _"main"_ dotfile that will source the other dotfiles. It's named `.shellrc` in the repository because it's generic, but it will be symlinked to your homefolder to the name commonly used by your shell. Only zsh (.zshrc) and bash (.bashrc) supported for now.

The only purpose of this file is to source the other dotfiles in this repository, and possibly your local modifications of the same files if you have any in `~/.local/dotfiles`.

See [.shellrc](.shellrc) for which filenames it checks for. As you might notice, some of the files are not in this repository (.path and .extra). That is because it doesn't make sense to share those. Instead you can create those files locally for modifying your PATH and `.extra` for anything that doesn't fit in any of the other dotfiles.

> [!WARNING]
> I'm using macOS and ZSH with [oh-my-zsh](https://ohmyz.sh/#install), but the dotfiles has checks to work in bash, and on Linux. In theory it should work in Windows with WSL, but this hasn't been tested yet.

## Dependencies

* [gh](https://github.com/cli/cli?tab=readme-ov-file#installation) - needed by alias ghwatch

### Optional dependencies

* [Oh My ZSH!](https://ohmyz.sh/)

        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    If you use zsh and have Oh My ZSH! installed, a default configuration in .exports will be loaded. Add your local overrides from this configuration in `~/.local/dotfiles/.exports`.

* Powerline fonts (if using Oh My ZSH!)

    The configured ZSH theme, agnoster, depends on this font for the prompt to work correctly:

        git clone https://github.com/powerline/fonts.git --depth=1
        cd fonts
        ./install.sh

    Update your terminal settings to use one of the Powerline fonts, like Menlo.

## Installation

1. Install the dependencies you need manually.

1. Clone this repository into a folder of your choice.

        git clone https://github.com/gregersrygg/dotfiles/

1. Run the install script.

    The [install.sh](install.sh) creates symlinks from your home directory to where you checked out the source code. This makes it possible to `git pull` changes without having to re-install the files. It also creates files in `~/.local/dotfiles` unless they already exist, which can be used to add your local changes.

    If any of the symlinks collide with an existing file in the home folder it will create a backup file with the original filename postfixed with `.org`.

    There is also a check for existing symlinks, so it should be safe to re-run the script after updating the repository.

        cd dotfiles
        ./install.sh

1. Add your local modifications

    You should not edit any of the original files that are symlinked. Instead, add local changes in `~/.local/dotfiles/`. The install script makes sure this folder exists and creates the files if it doesn't exist already so it's easy to add your overrides.

    * Update `~/.local/dotfiles/.gitconfig` with your name and e-mail, and git credential helper if you want one.
    * See if you have configurations in your `.org` files in the home directory that you want to move to the corresponding file in `~/.local/dotfiles/`.

1. Start a new shell to test the changes

## Thanks to

- [Mathias Bynens](https://github.com/mathiasbynens/) for most of the [dotfiles](https://github.com/mathiasbynens/dotfiles) repo structure.
- [Simen S. Røstad](https://github.com/simensrostad) for sharing his aliases, tips, ideas and being an early tester of my dotfiles.
