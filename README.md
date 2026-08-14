# Gregers' dotfiles

As a developer working with the nRF Connect SDK (ncs) and Zephyr, I often encounter challenges when switching between branches and framework environments, which can sometimes disrupt my configuration or lead to the loss of important information. To address these issues, I have developed a set of dotfiles designed to streamline these tasks. This collection represents a combination of tips and tricks I've learned from colleagues and ideas I've explored independently. While many developers have their own shell customizations, sharing and collaborating on these configurations can help us all improve and discover more efficient ways to enhance our workflows.

Feel free to use these dotfiles and contribute your own ideas! :bulb:

## Table of Contents

* [Context](#context)
* [Getting Started](#getting-started)
    * [Prerequisites](#prerequisites)
    * [Linux dependencies](#linux-dependencies)
    * [Windows dependencies](#windows-dependencies)
    * [macOS dependencies](#macos-dependencies)
    * [Optional dependencies](#optional-dependencies)
* [Installation](#installation)
* [Usage](#usage)
    * [Add a new worktree (ngwa)](#add-a-new-worktree-ngwa)
    * [Remove an existing worktree (ngwr)](#remove-an-existing-worktree-ngwr)
    * [List worktrees (ngwl)](#list-worktrees-ngwl)
    * [cd to a worktree (ncd)](#cd-to-a-worktree-ncd)
    * [Open current worktree in VS Code (ncode)](#open-current-worktree-in-vs-code-ncode)
    * [Claude Code worktrees](#claude-code-worktrees)
        * [cd to a Claude Code worktree (wtcd)](#cd-to-a-claude-code-worktree-wtcd)
        * [Clean up stale worktrees (wtclean)](#clean-up-stale-worktrees-wtclean)
    * [aliases/functions](#aliasesfunctions)
        * [Zephyr related aliases/functions](#zephyr-related-aliasesfunctions)
        * [Other aliases/functions](#other-aliasesfunctions)
    * [Made for re-usability and local customizations](#made-for-re-usability-and-local-customizations)
        * [.shellrc](#shellrc)
* [Thanks to](#thanks-to)


## Context

Git worktree :christmas_tree: is a native git command that allows you to check out and work on multiple git branches at the same time.
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

Because Zephyr have west dependencies in sibling folders the typical worktree structure won't work very well. Instead I structure the worktrees like this:

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

### Made for re-usability and local customizations

The dotfiles are organized in a way that makes it easier to share the configuraiton with others, and others can modify locally what they want to change/override without having to modify the original files.

### .shellrc

This is the _"main"_ dotfile that will source the other dotfiles. It's named `.shellrc` in the repository because it's generic, but it will be symlinked to your homefolder to the name commonly used by your shell. Only zsh (.zshrc) and bash (.bashrc) supported for now.

The only purpose of this file is to source the other dotfiles in this repository, and possibly your local modifications of the same files if you have any in `~/.local/dotfiles`.

See [.shellrc](.shellrc) for which filenames it checks for. As you might notice, some of the files are not in this repository (.path and .extra). That is because it doesn't make sense to share those. Instead you can create those files locally for modifying your PATH and `.extra` for anything that doesn't fit in any of the other dotfiles.

> [!WARNING]
> I'm using macOS and ZSH with [oh-my-zsh](https://ohmyz.sh/#install), but the dotfiles has checks to work in bash, and on Linux. In theory it should work in Windows with WSL, but this hasn't been tested yet.

## Getting Started

### Prerequisites

* [Zephyr SDK toolchain](https://docs.zephyrproject.org/latest/develop/toolchains/zephyr_sdk.html#zephyr-sdk-installation)
* [gh](https://github.com/cli/cli?tab=readme-ov-file#installation) - needed by alias ghwatch
* [direnv](https://direnv.net/) - loads the per-worktree environment automatically

      brew install direnv

    The shell hook is set up for you in [.exports](.exports) (zsh and bash). direnv loads a folder's `.envrc` when you `cd` into it or any of its subfolders, and reverts the changes when you leave.

    > [!NOTE]
    > direnv refuses to load an `.envrc` until you approve it with `direnv allow`. `ngwa` does that for you when it creates a worktree. If you ever edit a worktree's `.envrc` by hand, run `direnv allow` again.

### Linux dependencies

* notify-send

    Allows you to send desktop notifications from commandline.

      sudo apt install libnotify-bin

### Windows dependencies

* toast

    Allows you to send Windows desktop notifications from WSL.

    Compile yourself or download pre-compiled exe from the [GitHub repo](https://github.com/go-toast/toast).

    Add the exe to your PATH.

### macOS dependencies

* Docker

    To be able execute twister tests in native_sim on macOS.

### Optional dependencies

* [Oh My ZSH!](https://ohmyz.sh/)

      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    If you use zsh and have Oh My ZSH! installed, a default configuration in .exports will be loaded. Add your local overrides from this configuration in `~/.local/dotfiles/.exports`.

* fzf - A command line fuzzy finder plugin for Oh My ZSH

      git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin

* Powerline fonts (if using Oh My ZSH!)

    The configured ZSH theme, agnoster, depends on this font for the prompt to work correctly:

      git clone https://github.com/powerline/fonts.git --depth=1
      cd fonts
      ./install.sh

    Update your terminal settings to use one of the Powerline fonts, like Menlo.

## Installation

1. Install the [prerequisites](#prerequisites) and dependencies you need for your system.

2. Clone this repository into a folder of your choice.

       git clone https://github.com/gregersrygg/dotfiles/

3. Run the install script.

    The [install.sh](install.sh) creates symlinks from your home directory to where you checked out the source code. This makes it possible to `git pull` changes without having to re-install the files. It also creates files in `~/.local/dotfiles` unless they already exist, which can be used to add your local changes.

    If any of the symlinks collide with an existing file in the home folder it will create a backup file with the original filename postfixed with `.org`.

    There is also a check for existing symlinks, so it should be safe to re-run the script after updating the repository.

       cd dotfiles
       ./install.sh

4. Add your local modifications.

    You should not edit any of the original files that are symlinked. Instead, add local changes in `~/.local/dotfiles/`. The install script ensures this folder exists and creates the files if they don't already exist, making it easy to add your overrides.

    * Update `~/.local/dotfiles/.gitconfig` with your name, email, and git credential helper if desired. Uncomment the `[user]`, `[credential]`, and updated fields.
    * Check if you have configurations in your `.org` files in the home directory that you want to move to the corresponding file in `~/.local/dotfiles/`.
    * Update and uncomment the paths for `NCS_PATH` and `NCS_WT_PATH` in `~/.local/dotfiles/.exports`. If one of these folders doesn't exist, create them.

5. Start a new shell to test the changes.

### Migrating existing worktrees from dotenv to direnv

These dotfiles used to rely on the Oh My ZSH `dotenv` plugin and a `.env` file per worktree. If you have worktrees created before the switch, give each of them an `.envrc` and approve it:

```bash
for wt in $NCS_WT_PATH/*/; do
    cp ~/.wtenvrc "$wt/.envrc"
    direnv allow "$wt/.envrc"
done

# and the main checkout, if it has a .env
cp ~/.wtenvrc $NCS_PATH/.envrc
direnv allow $NCS_PATH/.envrc
```

The old `.env` files are ignored from then on and can be deleted.

## Usage

### Add a new worktree

`ngwa` is short for ncs-git-worktree-add

It will create a worktree with the same name as the branch in your configured `NCS_WT_PATH` folder. It will add a direnv `.envrc` file (and `direnv allow` it) so environment variables are set correctly for that worktree, and initialize a new python virtualenv to scope pip dependencies to that worktree only.

Then it will install west (in the virtualenv). Do a west init and update, and install requirements.txt from nRF, Zephyr and mcuboot.

```bash
ngwa <branch-name>
```

`<branch-name>` can be an existing branch you have locally, a new branch that you want to create, or a PR from `upstream` by using the branch name `pr-<number>`.

*Use TAB-completion to list your most recent branches.*

### Remove an existing worktree

`ngwr` is short for ncs-git-worktree-remove.

It's good practice to clean up your workspaces after you're done with it.

```bash
ngwr <worktree-name>
```

*Use TAB-completion to list your worktrees.*

### List worktrees

`ngwl` list the worktrees. Just saves typing out `git worktree list`, and it can be called from any folder.

```bash
ngwl
```

### cd to a worktree

`ncd` helps switch between the worktree folders. direnv picks up the worktree's `.envrc` on the way in and drops it again when you leave.

```bash
# cd to ncs/nrf
ncd

# cd to worktree named foo
ncd foo
```

*Use TAB-completion to list your worktrees*

### Open current worktree in VS Code

`ncode` is a shortcut to open a VS Code workspace for the current worktree.

### Claude Code worktrees

[Claude Code](https://claude.ai/code) can create git worktrees in `.claude/worktrees/` when started with the `--worktree` flag. The auto-generated names (e.g. `abstract-wobbling-gadget`) make it hard to navigate to them manually. These functions help with that.

#### cd to a Claude Code worktree (wtcd)

`wtcd` works from any directory inside a git repo.

```bash
# Interactive picker (requires fzf) showing worktree name, branch, and latest commit
wtcd

# cd directly to a worktree by name
wtcd abstract-wobbling-gadget
```

*Use TAB-completion to list available worktrees.*

#### Clean up stale worktrees (wtclean)

`wtclean` scans `.claude/worktrees/` and identifies worktrees that are safe to remove: PRs that have been merged (detected via `gh` CLI, works with squash merges) and unused branches with no commits ahead of main. Shows a colored summary and prompts before deleting.

```bash
# Interactive — shows status table, asks for confirmation
wtclean

# Skip confirmation prompt
wtclean -f
```

Auto-generated branch names (`worktree-*`) are cleaned up along with the worktree. User-named branches are left intact.

## Aliases/Functions

### Zephyr related aliases/functions

| Name     | Description                                  |
|----------|----------------------------------------------|
| wb       | west build                                   |
| wf       | west flash using the debugger with the highest device id (usually prefers external debuggers) |
| rmb      | rm build folder                              |
| wfe      | west flash --erase (and same as wf)          |
| wfr      | west flash --recover (and same as wf)        |
| wb????   | west build for nRF???? DK                    |
| rwb????  | Same as wb??? but deletes build folder first |
| ncd      | ncs cd (see section above)                   |
| ngwa     | ncs git worktree add (see section above)     |
| ngwr     | ncs git worktree remove (see section above)  |
| ncode    | Open VS Code for the current NCS root folder |
| pmr      | Partition Manager report                     |
| mc       | menuconfig                                   |
| greb     | grep <filename> <searchstring> in the build folder |
| grebc    | grep in .config files in the build folder    |
| a2l <addr> | addr2line alias for application image      |
| zd <cmd> | Run a command inside a Zephyr docker container |
| zdi      | Start Zephyr docker container as an interactive terminal |
| twister  | Run `west twister` using zd (see above)      |

### Other aliases/functions

| Name       | Description                                  |
|------------|----------------------------------------------|
| ??         | ?? <copilot shell related question>          |
| gh??       | gh?? <copilot gh related question>           |
| git??      | git?? <copilot git related question>         |
| bell       | PC beep (useful after long running commands) |
| notify     | Desktop notification (useful after long running commands) |
| certinfo   | OpenSSL certificate info for non elliptic curve certificates |
| certinfoec | OpenSSL certificate info for non elliptic curve certificates |
| wtcd       | cd to a Claude Code worktree (see [section above](#cd-to-a-claude-code-worktree-wtcd)) |
| wtclean    | Clean up stale Claude Code worktrees (see [section above](#clean-up-stale-worktrees-wtclean)) |

## Thanks to

- [Mathias Bynens](https://github.com/mathiasbynens/) for most of the [dotfiles](https://github.com/mathiasbynens/dotfiles) repo structure.
- [Simen S. Røstad](https://github.com/simensrostad) for sharing his aliases, tips, ideas and being an early tester of my dotfiles.