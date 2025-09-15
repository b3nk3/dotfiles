{
  description = "Initial nix-darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile
      environment.systemPackages = with pkgs; [
        # Add your packages here
      ];

      # Nix configuration
      nix.enable = false;

      # Create /etc/zshrc that loads the nix-darwin environment
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing
      system.stateVersion = 4;

      # The platform the configuration will be used on
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations.Mac = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}