# modules/system-packages/common.nix
# System packages configuration - reusable across macOS and Linux
{ pkgs, stable, ... }:
{
  environment.systemPackages = with pkgs; [
    # apps
    obsidian

    # dev tools
    doppler
    go
    golangci-lint
    goreleaser
    gh
    neovim
    nixfmt
    nodejs_24 # Node.js 24 as default
    nodePackages.pnpm
    ollama
    tenv
    stable.turbo
    zig

    # shell
    fzf
    zoxide
    oh-my-posh
  ];
}
