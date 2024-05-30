# Gregers's dotfiles

Here are my dotfiles that I mainly use to develop with Zephyr for Nordic Semiconductor.
It's mostly a collection of tips and tricks I've gathered from colleagues and some ideas I've explored myself.
We all have a lot of shell customizations, but if we share and contribute openly we can learn from each other to get even better shell customizations.
Please use, and contribute with new ideas :bulb:.

## Main features

### Git worktree for ncs :christmas_tree:

Git worktree is a native git command that allows you to check out and work on multiple git branches at the same time.
When you're in the middle of working on a new feature, it can be painful to clean up uncommited changes or deal with untracked files. With worktrees you just add a new worktree for the branch you need to check out. Because it's checked out in a different folder it won't conflict with your existing worktrees.

Typically git worktrees have a folder structure like this:

```
~
└- dev/
   ├- myproject/           <- main branch
   └- myprojectwt/
      ├- add-new-feature   <- add-new-feature branch
      ├- fix-bug           <- fix-bug branch
      ├- ...
```

Because zephyr have west dependencies in sibling folders the typical worktree structure won't work very well. Instead I structure the worktrees like this:

```
~
└- dev/
   ├- ncs
   |  └- nrf              <- main branch
   └- ncswt/
      ├- add-new-feature
      |  └- nrf           <- add-new-feature branch
      ├- fix-bug
      |  └- nrf           <- fix-bug branch
      ├- ...
```

Since setting up the dependencies and isolating them is a bit of extra work, I've made a bash function to simplify adding, removing, listing and cd-ing between the worktrees.

#### Add a new worktree (ngwa)

ngwa is short for ncs-git-worktree-add

It will create a worktree with the same name as the branch in your configured `NCS_WT_PATH` folder. It will add a `.env` file so environment variables are set correctly for that worktree and initialize a new python virtualenv to scope pip dependencies to that worktree only.

Then it will install west (in the virtualenv). Do a west init and update, and install requirements.txt from nrf, zephyr and mcuboot.

```bash
ngwa <branch-name>
```

_branch-name_ can be an existing branch you have locally, a new branch that you want to create, or a PR from `upstream` by using the branch name `pr-<number>`.

Use TAB-completion to list your most recent branches.

#### Remove an existing worktree (ngwr)

ngwr is short for ncs-git-worktree-remove

It's good practice to clean up your workspaces after you're done with it.

```bash
ngwr <worktree-name>
```

Use TAB-completion to list your worktrees

#### cd to a worktree (ncd)

It's a bit cumbersome to switch between the folders, and especially to trigger the `.env` file at the same time.
`ncd` to the rescue.

```bash
# cd to ncs/nrf
ncd

# cd to worktree named foo
ncd foo
```

Use TAB-completion to list your worktrees

#### list worktrees

Not that much magic here. Just saves typing out `git worktree list`, and it can be called from any folder.

```bash
ngwl
```

### aliases/functions

#### Zephyr related aliases/functions

| Name    | Description                                  |
|---------|----------------------------------------------|
| wb      | west build                                   |
| wf      | west flash using the debugger with the highest device id (usually prefers external debuggers) |
| rmb     | rm build folder                              |
| wfe     | west flash --erase (and same as wf)          |
| wfr     | west flash --recover (and same as wf)        |
| wb????  | west build for nRF???? DK                    |
| rwb???? | Same as wb??? but deletes build folder first |
| ncd     | ncs cd (see section above)                   |
| ngwa    | ncs git worktree add (see section above)     |
| ngwr    | ncs git worktree remove (see section above)  |
| pmr     | Partition Manager report                     |
| mc      | menuconfig                                   |
| greb    | grep <filename> <searchstring> in the build folder |
| grebc   | grep in .config files in the build folder    |

#### Other aliases/functions

| Name       | Description                                  |
|------------|----------------------------------------------|
| ??         | ?? <copilot shell related question>          |
| gh??       | gh?? <copilot gh related question>           |
| git??      | git?? <copilot git related question>         |
| bell       | PC beep (useful after long running commands) |
| notify     | Desktop notification (useful after long running commands) |
| certinfo   | OpenSSL certificate info for non elliptic curve certificates |
| certinfoec | OpenSSL certificate info for non elliptic curve certificates |

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
* dotenv

    If you don't use zsh and Oh My ZSH you need to find a dotenv alternative. There are many, but as long as it can automatically source a `.env` file in a folder it doesn't matter which project you use.

### Linux dependencies

* notify-send

    Allows you to send desktop notifications from commandline.

        sudo apt install notify-send

### Windows dependencies

* toast

    Allows you to send Windows desktop notifications from WSL.

    Compile yourself or download pre-compiled exe from the [GitHub repo](https://github.com/go-toast/toast).

    Add the exe to your PATH.

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
