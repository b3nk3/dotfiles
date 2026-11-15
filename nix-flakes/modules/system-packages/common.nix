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
    nodejs_26
    # pnpm must run under the same node; the default build uses nodejs_24,
    # which has a broken fd-tracking bug on darwin (nixpkgs #536039)
    (pnpm.override { nodejs-slim = nodejs-slim_26; })
    # the nixpkgs wrapper bundles vfkit/krunkit/gvproxy, so `podman machine` works without extra PATH setup
    podman
    tenv
    stable.turbo
    zig

    # shell
    fzf
    zoxide
    oh-my-posh
  ];
}
