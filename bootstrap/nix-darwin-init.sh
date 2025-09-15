#!/bin/bash
set -e  # Exit on any error

echo "Setting up nix-darwin with flakes..."

# Create configuration directory
mkdir -p ~/.config/nix-darwin

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the actual configuration name from flake.nix
FLAKE_SOURCE="$SCRIPT_DIR/flake.nix"
if [ ! -f "$FLAKE_SOURCE" ]; then
    echo "Error: flake.nix not found at $FLAKE_SOURCE"
    echo "Please ensure flake.nix exists next to the script file"
    exit 1
fi

# Create flake.nix configuration
cp "$FLAKE_SOURCE" ~/.config/nix-darwin/flake.nix

# Extract configuration name from flake.nix
CONFIG_NAME=$(grep -o 'darwinConfigurations\.[^[:space:]]*' ~/.config/nix-darwin/flake.nix | sed 's/darwinConfigurations\.//' | sed 's/[^a-zA-Z0-9_-].*$//')
if [ -z "$CONFIG_NAME" ]; then
    echo "Warning: Could not detect configuration name from flake.nix"
    CONFIG_NAME="default"
fi

echo "Created flake.nix configuration"
echo "Detected configuration name: $CONFIG_NAME"

# Initial bootstrap
echo "Running initial nix-darwin setup with sudo..."
if [ "$CONFIG_NAME" != "default" ]; then
    sudo nix run nix-darwin -- switch --flake ~/.config/nix-darwin#$CONFIG_NAME
else
    sudo nix run nix-darwin -- switch --flake ~/.config/nix-darwin
fi

echo ""
echo "✅ nix-darwin setup complete!"
echo ""
echo "You can now use:"
if [ "$CONFIG_NAME" != "default" ]; then
    echo "  sudo darwin-rebuild switch --flake ~/.config/nix-darwin#$CONFIG_NAME"
else
    echo "  sudo darwin-rebuild switch --flake ~/.config/nix-darwin"
fi
echo ""
echo "To edit your configuration:"
echo "  \$EDITOR ~/.config/nix-darwin/flake.nix"
echo ""
echo "Your configuration name is: $CONFIG_NAME"