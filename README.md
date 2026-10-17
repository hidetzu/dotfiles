# hidetzu's dotfiles

[![ci](https://github.com/hidetzu/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/hidetzu/dotfiles/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

The Mac is the client. Arch Linux is the development machine.

```text
┌────────────────────────────┐                    ┌──────────────────────────┐
│ client: macOS              │                    │ devhost: Arch Linux      │
│                            │   WezTerm SSHMUX   │                          │
│ WezTerm                    │ ─────────────────▶ │ wezterm mux server       │
│ dev (project launcher)     │ ─────────────────▶ │ fish, Neovim + LSP       │
│ VS Code (Remote SSH)       │        ssh         │ Claude Code, Codex       │
│ Brewfile, macOS defaults   │                    │ Docker, toolchains       │
└────────────────────────────┘                    └──────────────────────────┘
```

Panes live on the devhost, so they survive a disconnect, and a split opens in the same remote directory.

## What this repo manages

| Role | Machine | Responsibility |
|---|---|---|
| `client` | macOS | WezTerm, `dev` (project launcher), VS Code Remote SSH settings, Brewfile, macOS defaults |
| `devhost` | Arch Linux | source code, Neovim LSP servers, WezTerm mux server, Claude Code / Codex, pacman packages |
| `common` | both | git config and hooks, fish, starship, Neovim config |

## Verified by CI

CI verifies shell scripts, idempotent deployment on macOS / Arch Linux, and a full Arch devhost setup.

## Quick start

```sh
git clone https://github.com/hidetzu/dotfiles.git ~/dotfiles
cd ~/dotfiles
make init      # install packages and tools for this machine's role
make deploy    # symlink the config files into $HOME
make check     # verify every link
```

- `make` needs the Xcode Command Line Tools on macOS (`xcode-select --install`), or `base-devel` on Arch (`sudo pacman -S --needed base-devel`).
- The role defaults to `client` on macOS and `devhost` on Linux. Override it with `ROLE=…`.
- `make list ROLE=devhost` shows what a role would link, on any machine.

## Daily use

### Open a project on the devhost

```sh
dev dotfiles                # Neovim on the devhost, in a new WezTerm tab (SSHMUX)
dev -c dotfiles             # VS Code Remote SSH instead
DEV_HOST=otherhost dev foo  # default host: arch (Host name in ~/.ssh/config)
```

`dev` asks the devhost's `project-path` for candidates and picks one with fzf when the name is ambiguous. Candidates are the git repositories up to 3 levels under `$PROJECT_ROOTS` (default `~/work ~/repos`), plus those directly under `$HOME`.

### WezTerm keys

The leader key is `Ctrl+t`.

| Key | Action |
|---|---|
| `LEADER a` / `LEADER d` | attach to / detach from the devhost (`SSHMUX:arch`) |
| `LEADER v` / `LEADER s` / `LEADER c` | split / new tab, in the current pane's host and directory |
| `LEADER w` | fuzzy-search the panes in all tabs by host, directory and title |
| `Ctrl+Shift+Y` | copy the previous command's output (local panes only, via OSC 133) |

### Shell and editor

| | |
|---|---|
| fish | vi mode, starship prompt, fzf keys (`ctrl-t` files, `ctrl-r` history, `alt-c` cd) |
| fish functions | `gcp` (pick commits to cherry-pick), `fm` (cd to `~/memo`), `y` (yazi, then cd) |
| Neovim | LSP with the built-in keys (`grr` / `gri` / `grn` / `gra` / `gO` / `K`); `gd` and the lists go through fzf-lua |
| Neovim, continued | format on save (conform.nvim), lint (nvim-lint), completion (nvim-cmp) |
| Notes | `zemo` opens and syncs notes in the private `~/memo` repository ([zemo](https://github.com/hidetzu/zemo)) |

## Layout

```text
common/   always       nvim, fish, starship, git (config, hooks, ignore)
client/   the client   WezTerm, dev, wezterm-match; macOS: Brewfile, defaults, VS Code
devhost/  the devhost  project-path, WezTerm mux server, Claude Code, gh, Go / mise, packages
lib/dotfiles.sh        deploy / check / init / list
```

Each role directory can contain the same parts:

| Path | Used by | What it holds |
|---|---|---|
| `links` | `deploy`, `check` | one `repo-path  $HOME-path` per line |
| `init/*.sh` | `init` | installers, run in name order |
| `deploy.sh`, `check.sh` | `deploy`, `check` | extra steps (devhost: generates Claude Code's `settings.json`) |
| `mac/`, `linux/`, `arch/` | all | platform-specific parts, run before the role's own (`arch` → `linux` → role) |

When `deploy` finds a regular file in place of a link, it moves the file to `<file>.bak.<timestamp>` (unless the contents are identical). Broken links that still point into the repository are removed.

## Private layer

Personal settings that should not be public, such as the git `[user]` identity, live in a private repository with the same layout: `~/dotfiles-private`, or the path in `DOTFILES_PRIVATE`. When it exists, every command reads its layers too. When both repositories define the same thing:

| What | Rule |
|---|---|
| a `links` entry for the same `$HOME` path | the private one wins |
| `devhost/claude/settings.json` | deep merge: the private value wins, and arrays are replaced |
| `init/*.sh`, `deploy.sh`, `check.sh` | all of them run |

## Claude Code settings

`~/.claude/settings.json` is generated, not linked. It is `devhost/claude/settings.json` merged with the private one.

- `autoMode` is per machine. `deploy` keeps it, and `check` ignores it.
- When Claude Code edits the file (e.g. `/config`), `make check` shows the difference. Copy the change into the right repository and run `make deploy`. Deploying without doing that first saves the edited file as `settings.json.bak.<timestamp>`.

## Init scripts

| Script | Role | What it does |
|---|---|---|
| `brew.sh`, `defaults.sh` | client (macOS) | `brew bundle` with the `Brewfile`; Finder / Dock / keyboard defaults |
| `wezterm-terminfo.sh` | client | install the `wezterm` terminfo into `~/.terminfo` (macOS has none) |
| `bash-path.sh` | all | put `~/.local/bin` on bash's `PATH` |
| `00-packages.sh` | devhost (Arch) | pacman packages, with a full upgrade (`pacman -Syu`, never a partial upgrade) |
| `docker.sh` | devhost (Linux) | enable the docker daemon (skipped without systemd) |
| `claude.sh`, `codex.sh`, `zemo.sh` | devhost | Claude Code, OpenAI Codex and zemo into `~/.local/bin` |

A failing script does not stop the rest. The failures are listed at the end, and the command exits non-zero.

## Maintenance

### Keep the WezTerm builds in step

The mux protocol needs the **same build** on both sides. The client runs `wezterm@nightly`, and the devhost runs the same nightly from `~/.local/opt/wezterm/<version>`:

```sh
wezterm-match                                   # compare the two builds
brew upgrade --cask --greedy wezterm@nightly
ssh arch "~/.local/bin/wezterm-mux-install $(wezterm --version | cut -d' ' -f2)"
```

The nightly download only has the latest build, so update both sides together. A mux server that is still running keeps its old build until it stops. If the builds differ, `SSH:arch` (no mux) still works, and `dev` falls back to plain `ssh`.

### Commit messages

A global `commit-msg` hook (`core.hooksPath = ~/.config/git/hooks`) enforces [Conventional Commits](https://www.conventionalcommits.org/) in every repository:

- the type is one of `feat` `fix` `docs` `style` `refactor` `perf` `test` `chore` `ci` `build` `revert`
- the subject is at most 72 characters, and the header at most 100
- `Merge …`, `Revert …`, `fixup!` and `squash!` are skipped

To opt a repository out: `git config core.hooksPath .git/hooks`.

### Auto-merge

`auto-merge.yml` turns on squash auto-merge for the owner's own pull requests and deletes the branch after the merge. It refuses to run unless `main` has a ruleset with these required checks: `shellcheck`, `deploy (arch-devhost)`, `deploy (macos-client)`, `init-arch-devhost`, with "require branches to be up to date". The repository settings also need **Allow auto-merge** and **Automatically delete head branches**.

### More

- [docs/arch-gpu.md](docs/arch-gpu.md): yay, NVIDIA drivers, CUDA and Docker GPU support on the devhost

## License

[MIT](LICENSE)
