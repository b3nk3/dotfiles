# Dotfiles

MacOS system configuration using nix-darwin and home-manager.

## Features

- **System Management**: Using nix-darwin and homebrew
- **Modular Configuration**: Reusable modules for homebrew and system packages
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
sudo darwin-rebuild switch --flake ./nix-flakes#macbook
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
├── bootstrap/
│   ├── flake.nix    # Bootstrap flake configuration
│   └── nix-darwin-init.sh  # Initial setup script
├── nix-flakes/
│   ├── flake.lock   # Flake lock file
│   ├── flake.nix    # System and flake configuration
│   ├── home.nix     # Home-manager configuration
│   └── modules/     # Reusable configuration modules
│       ├── homebrew/
│       │   └── common.nix  # Homebrew packages and configuration
│       └── system-packages/
│           └── common.nix  # System packages configuration
```

### Modules

The `modules/` directory contains reusable configuration modules that can be shared across different platform configurations (macOS via nix-darwin, and potentially Linux/NixOS in the future):

- **`modules/homebrew/common.nix`**: Homebrew packages (brews, casks, taps) and configuration
- **`modules/system-packages/common.nix`**: System packages installed via nixpkgs

These modules are automatically merged by the nix-darwin module system, allowing for easy organization and potential cross-platform reuse.

## Updating

```bash
nix flake update --flake ./nix-flakes
```

```bash
sudo darwin-rebuild switch --flake ./nix-flakes#macbook
```
