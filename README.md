Ah, you're right! Let me fix the structure one more time to match your exact file layout:

# Dotfiles

MacOS system configuration using nix-darwin and home-manager.

## Features

- **System Management**: Using nix-darwin and homebrew
- **Node.js Version Management**: Easy switching between Node.js 18, 20, 22
- **Shell Configuration**: Zsh with zinit plugin management
- **Dotfile Management**: Via home-manager

## Installation

```bash
# 1. Install Nix
sh <(curl -L https://nixos.org/nix/install)

# 2. Enable Flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# 3. Clone and Build
git clone [your-repo-url]
cd [repo-name]
darwin-rebuild switch --flake .#macbook
```

## Usage

### Node.js Version Switching

```bash
use_node18  # Switch to Node.js 18
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
└── nix-darwin
    ├── flake.lock   # Flake lock file
    ├── flake.nix    # System and flake configuration
    └── home.nix     # Home-manager configuration
```

## Updating

```bash
darwin-rebuild switch --flake ./nix-darwin#macbook
```

## License

[Your chosen license]
