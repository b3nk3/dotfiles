# Dotfiles

MacOS system configuration using nix-darwin and home-manager.

## Features

- **System Management**: Using nix-darwin and homebrew
- **Node.js Version Management**: Easy switching between Node.js 18, 20, 22
- **Shell Configuration**: Zsh with zinit plugin management
- **Dotfile Management**: Via home-manager

## Installation

```bash
# 1. Install Nix from Determinate Systems https://docs.determinate.systems/
Linux: curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
MacOS: https://install.determinate.systems/determinate-pkg/stable/Universal

# 2. Clone and bootstrap nix-darwin (installs darwin-rebuild etc.)
git clone https://github.com/benszabo/dotfiles.git
./bootstrap/nix-darwin-init.sh

# 3. Build and switch to the configuration
sudo darwin-rebuild switch --flake ./nix-darwin#macbook
```

## Usage

### Node.js Version Switching

```bash
use_node20  # Switch to Node.js 20
use_node22  # Switch to Node.js 22
use_default # Switch to system default
```

### Shell Features

- Syntax highlighting and autosuggestions
- FZF integration with enhanced tab completion
- Git and AWS command completion
- Custom key bindings for history search
- Directory jumping with zoxide

## Structure

```
.
├── README.md
├── .zshrc           # Shell configuration
├── .gitconfig       # Git configuration
├── .ghostty.txt     # Ghostty terminal configuration
├── .omp_zen.toml    # Oh My Posh theme configuration
├── nix-darwin
│   ├── flake.lock   # Flake lock file
│   ├── flake.nix    # System and flake configuration
│   └── home.nix     # Home-manager configuration
```

## Updating

```bash
nix flake update --flake ./nix-darwin
```

```bash
sudo darwin-rebuild switch --flake ./nix-darwin#macbook
```
