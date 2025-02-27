# flake.nix
{
  description = "Ben's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, nixpkgs, home-manager }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        nixpkgs.config.allowUnfree = true;

        homebrew = {
          enable = true;
          brews = [
            "awscli"
            "aws-sso-util"
            "derailed/k9s/k9s"
            "easy-rsa"
            "granted"
            "mas"
            "terraform-docs"
          ];
          casks = [
            "iina"
            "raycast"
            "the-unarchiver"
          ];
          taps = [
            "common-fate/granted"
          ];
          masApps = {
            #  Install Mac App Store apps 
            # use mas-cli to get their id
            # Need to be logged in and to have purchased the app before
            # "Yoink" = 457622435;
          };
          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
        };

        environment.systemPackages = with pkgs; [
          # apps
          obsidian

          # dev tools
          bruno # https://www.usebruno.com/
          doppler
          go
          goreleaser
          gh
          mise
          nixpkgs-fmt
          nodejs # Latest stable version
          nodePackages.pnpm
          tenv

          # shell
          fzf
          zoxide
          oh-my-posh
        ];





        fonts.packages = [
          pkgs.nerd-fonts.jetbrains-mono
        ];



        # Auto upgrade nix package and the daemon service.
        nix.enable = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        # default shell on catalina and up
        # Configure zsh with the Node.js version switching functions
        programs.zsh = {
          enable = true;
          interactiveShellInit =
            let
              node18 = pkgs.nodejs_18;
              node20 = pkgs.nodejs_20;
              node22 = pkgs.nodejs_22;
            in
            ''
              function use_node18() {
                export PATH="${node18}/bin:$(echo $PATH | sed 's|/nix/store/[^:]*nodejs[^:]*bin:||g')"
                echo "Now using Node.js $(node --version)"
              }
            
              function use_node20() {
                export PATH="${node20}/bin:$(echo $PATH | sed 's|/nix/store/[^:]*nodejs[^:]*bin:||g')"
                echo "Now using Node.js $(node --version)"
              }

              function use_node22() {
                export PATH="${node22}/bin:$(echo $PATH | sed 's|/nix/store/[^:]*nodejs[^:]*bin:||g')"
                echo "Now using Node.js $(node --version)"
              }

              function use_node_default() {
                export PATH="${pkgs.nodejs}/bin:$(echo $PATH | sed 's|/nix/store/[^:]*nodejs[^:]*bin:||g')"
                echo "Now using Node.js $(node --version)"
              }
            '';
        };
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        # enable TouchID for sudo commands in terminal
        security.pam.services.sudo_local.touchIdAuth = true;

        # home manager
        users.users.benszabo.home = "/Users/benszabo";
        home-manager.backupFileExtension = "backup";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.benszabo = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "benszabo";

              # Automatically migrate existing Homebrew installations
              # autoMigrate = true;
            };
          }



        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."macbook".pkgs;
    };
}
