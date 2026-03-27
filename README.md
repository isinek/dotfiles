# dotfiles

Personal workstation bootstrap for macOS and Arch/Linux via Homebrew.

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

- `homebrew`: installs CLI tools and apps from `homebrew/Brewfile`
- `bashrc`: links `~/.bashrc.user` and `~/.bash_aliases`, and links `~/.bashrc.work` only in work mode
- `helix`: links Helix config files
- `ghostty`: installs Ghostty on macOS and links its config
- `alacritty`: installs Alacritty and links its config
- `aerospace`: macOS-only; installs AeroSpace and links `~/.aerospace.toml`
- `tmux`: links tmux config and installs TPM
- `starship`: installs and links Starship config
- `gh`: installs GitHub CLI and links its config
- `prettier`: installs Prettier, required plugins, and links `~/.prettierrc`

## Work Mode

`./setup.sh -w ...` enables workstation-only setup.

Without `-w`, `homebrew/setup.sh` skips:
- `asdf`
- `tailscale`
- `protoc-gen-go-grpc`
- `protoc-gen-go`
- `protoc-gen-js`
- `1password-cli`
- `1password`
- `dbeaver-community`
- `postman`
- `slack`

`bashrc/.bashrc.work` is also only linked in work mode. That file currently contains:
- `GOPRIVATE`
- `asdf` shims on `PATH`
- `op` completion

## Behavior

- Setup scripts are intended to be rerunnable.
- The repository is treated as read-only input. Setup scripts must only write outside the repo.
- Most configs are symlinked into `$HOME`.
- `bashrc/setup.sh` is a special case: if `~/.bashrc` already sources `~/.bashrc.user`, it exits without changing anything.
- `homebrew/setup.sh` installs packages from `homebrew/Brewfile`.
- macOS-only apps are gated in the Brewfile and skipped by setup scripts on Linux.
- Linux support means Homebrew on Linux, not native Arch packages.
