# dotfiles

Personal workstation bootstrap for macOS and Linux via Homebrew.

## Usage

List available targets:

```bash
./setup.sh -h
```

Run one or more setup targets from the repo root:

```bash
./setup.sh homebrew bashrc helix tmux prettier
```

Enable work-only packages and apps:

```bash
./setup.sh -w homebrew bashrc
```

## Targets

- `homebrew`: installs CLI tools and apps from `homebrew/Brewfile.home`, plus `homebrew/Brewfile.work` in work mode
- `bashrc`: links `~/.bashrc.user` and `~/.bash_aliases`, and links `~/.bashrc.work` only in work mode
- `eza`: installs `eza` if missing and links its config
- `helix`: installs Helix if missing and links `config.toml` and `languages.toml`
- `ghostty`: installs Ghostty on macOS and links its config
- `aerospace`: macOS-only; installs AeroSpace and links `~/.aerospace.toml`
- `tmux`: links tmux config and installs TPM
- `starship`: installs and links Starship config
- `gh`: installs GitHub CLI and links its non-secret config
- `prettier`: installs Prettier, required plugins, and links `~/.prettierrc`

## Work Mode

`./setup.sh -w ...` enables workstation-only setup.

Without `-w`, `homebrew/setup.sh` skips everything from `homebrew/Brewfile.work`.

Work-only brew formulas:
- `asdf`
- `colima`
- `docker-credential-helper`
- `nx`
- `protoc-gen-go-grpc`
- `protoc-gen-go`
- `protoc-gen-js`
- `stern`
- `tailscale`

Work-only macOS casks:
- `1password-cli`
- `1password`
- `dbeaver-community`
- `mysql-shell`
- `postman`
- `slack`
- `temurin`

`bashrc/.bashrc.work` is also only linked in work mode. That file currently contains:
- `GOPRIVATE`
- `asdf` shims on `PATH`
- `PNPM_HOME`
- `op` completion

## Current Setup Notes

- `homebrew/Brewfile.home` is grouped by category and includes shell tools, file utilities, Git tooling, runtimes, developer tooling, language servers, and macOS desktop apps.
- `homebrew/Brewfile.work` is also grouped by category and is appended to `~/Brewfile` only when `-w` is used.
- Helix shell formatting is configured with `shfmt` for both `bash` and `zsh` in `helix/languages.toml`.
- `homebrew/Brewfile.home` includes `shellcheck` and `shfmt` for shell linting and formatting.

## Behavior

- Setup scripts are intended to be re-runnable.
- The repository is treated as read-only input. Setup scripts must only write outside the repo.
- Most configs are symlinked into `$HOME`.
- `setup.sh all` runs every top-level tool directory except `.git` and `lib`.
- `bashrc/setup.sh` is a special case: it creates `~/.bashrc` if needed, then ensures it sources `~/.bashrc.user`.
- `homebrew/setup.sh` writes `~/Brewfile` from `homebrew/Brewfile.home` and appends `homebrew/Brewfile.work` in work mode.
- If `~/Brewfile` already exists as a regular file with different contents, `homebrew/setup.sh` offers to back it up to `~/Brewfile.bak` before replacing it.
- After `brew bundle`, `homebrew/setup.sh` installs or updates the global `.NET` tool `csharp-ls` when `dotnet` is available.
- `gh/setup.sh` does not manage `~/.config/gh/hosts.yml`; `gh auth login` should own that file because it contains credentials.
- macOS-only apps are gated in the Brewfile and skipped by setup scripts on Linux.
- Linux support means Homebrew on Linux, not native distro packages.
