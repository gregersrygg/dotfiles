# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Shell dotfiles for nRF Connect SDK (NCS) / Zephyr development. Provides git worktree management, build aliases, and shell environment setup. Designed for macOS with zsh (oh-my-zsh), but supports bash and Linux.

## Installation and testing

```bash
./install.sh        # symlinks dotfiles to ~, creates ~/.local/dotfiles/, builds Docker image
source ~/.zshrc     # reload after changes (or start a new shell)
```

The install script is idempotent — safe to re-run. It backs up existing files as `*.org`.

## Architecture

**`.shellrc`** is the entrypoint — symlinked to `~/.zshrc` or `~/.bashrc`. It sources each dotfile in order: `.path`, `.exports`, `.aliases`, `.functions`, `.completion`, `.extra`. For each, it also sources a same-named override from `~/.local/dotfiles/` if present.

**Key environment variables** (set in `.exports`, user overrides in `~/.local/dotfiles/.exports`):
- `NCS_PATH` — main NCS checkout (default: `~/devel/ncs`)
- `NCS_WT_PATH` — worktree root (default: `~/devel/ncswt`)
- `ZEPHYR_BASE`, `ZEPHYR_TOOLCHAIN_PATH` — auto-detected

**`.wtenvrc`** is the template `.envrc` copied into each new worktree. It activates the venv, sets `ZEPHYR_BASE`, and adjusts `PATH`. [direnv](https://direnv.net/) auto-loads it on `cd` (hooked in at the end of `.exports`) and unloads it when you leave. `ngwa` runs `direnv allow` on the new file so it loads without prompting.

Because direnv searches parent directories and reverts its changes on exit, functions don't need to `cd` through the worktree root to trigger loading, and `.envrc` doesn't need to clean stale `zephyr/scripts` entries out of `PATH`.

**Worktree layout** (non-standard, required by west):
```
~/devel/ncswt/<branch>/nrf     ← the git worktree
~/devel/ncswt/<branch>/.envrc  ← copied from .wtenvrc
~/devel/ncswt/<branch>/.venv   ← isolated virtualenv
~/devel/ncswt/<branch>/zephyr, bootloader, ...  ← west dependencies
```

**Docker** (`Dockerfile`) extends `zephyrprojectrtos/zephyr-build` with Ruby for running twister tests on macOS via `zd`/`zdi` functions.

## Key conventions

- **Never edit symlinked files for user-specific config.** User overrides go in `~/.local/dotfiles/`. The `.local/dotfiles/` directory in the repo contains templates copied during install.
- All shell code must work in both **zsh and bash** — use `[[ -n $ZSH_VERSION ]]` / `[[ -n $BASH_VERSION ]]` guards where behavior differs.
- Platform checks use `[[ $(uname) == "Darwin" ]]` for macOS and `[[ $(uname) == "Linux" ]]` for Linux. WSL is detected via `which powershell.exe`.
- `.gitconfig` includes `~/.local/dotfiles/.gitconfig` for user identity and `~/.gitconfig.platform` for platform-specific settings.
- Don't add `PATH` modifications to `.exports` — use a `.path` file instead.

## Completion

Tab completion for `ncd`, `ngwa`, `ngwr` is in `.completion`. `ngwa` completes on recent branches (excluding those already checked out as worktrees). West completion is sourced from `west-completion.sh`.
