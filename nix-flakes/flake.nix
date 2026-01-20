# flake.nix
{
  description = "Ben's Darwin system flake";

  inputs = {
    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nix-homebrew,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
    }:
    let
      configuration =
        { pkgs, stable, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          nixpkgs.config.allowUnfree = true;

          # Set the primary user for system-wide options that require it.
          system.primaryUser = "benszabo";

          fonts.packages = [
            pkgs.nerd-fonts.jetbrains-mono
          ];

          # Auto upgrade nix package and the daemon service.
          nix.enable = false;
          # nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          # nix.settings.experimental-features = "nix-command flakes";

          # Create /etc/zshrc that loads the nix-darwin environment.
          # default shell on catalina and up
          # Configure zsh with the Node.js version switching functions
          programs.zsh = {
            enable = true;
            interactiveShellInit =
              let
                node20 = pkgs.nodejs_20;
                node22 = pkgs.nodejs_22;
                node24 = pkgs.nodejs_24;
              in
              ''

                function use_node20() {
                  export PATH="${node20}/bin:$(echo $PATH | sed 's|/nix/store/[^:]*nodejs[^:]*bin:||g')"
                  echo "Now using Node.js $(node --version)"
                }

                function use_node22() {
                  export PATH="${node22}/bin:$(echo $PATH | sed 's|/nix/store/[^:]*nodejs[^:]*bin:||g')"
                  echo "Now using Node.js $(node --version)"
                }

                function use_node24() {
                  export PATH="${node24}/bin:$(echo $PATH | sed 's|/nix/store/[^:]*nodejs[^:]*bin:||g')"
                  echo "Now using Node.js $(node --version)"
                }

                function use_node_default() {
                  export PATH="${node24}/bin:$(echo $PATH | sed 's|/nix/store/[^:]*nodejs[^:]*bin:||g')"
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

          security = {
            # enable TouchID for sudo commands in terminal
            pam.services.sudo_local.enable = true;
            pam.services.sudo_local.touchIdAuth = true;
            pam.services.sudo_local.text = "auth sufficient pam_tid.so.2"; # workaround...
          };

          # sysytem settings
          system.defaults = {
            dock = {
              orientation = "left";
              mineffect = "genie";
              minimize-to-application = true;
              autohide = true;
              show-recents = false;
              showAppExposeGestureEnabled = true;
              showDesktopGestureEnabled = true;
              showMissionControlGestureEnabled = true;
            };
            finder = {
              AppleShowAllFiles = true;
              # When performing a search, search the current folder by default
              FXDefaultSearchScope = "SCcf";
              FXRemoveOldTrashItems = true;
              ShowStatusBar = true;
            };
            trackpad = {
              TrackpadThreeFingerDrag = true;
              TrackpadFourFingerVertSwipeGesture = 2;
            };
            CustomUserPreferences = {
              "com.apple.desktopservices" = {
                # Avoid creating .DS_Store files on network or USB volumes
                DSDontWriteNetworkStores = true;
                DSDontWriteUSBStores = true;
              };
              "com.apple.finder" = {

              };
              "com.apple.symbolichotkeys" = {
                AppleSymbolicHotKeys = {
                  # Disable 'Cmd + Space' for Spotlight Search
                  # Key "64" is the identifier for the shortcut
                  "64" = {
                    enabled = false;
                  };
                  # Optionally, disable 'Cmd + Alt + Space' for Finder search window
                  # Key "65" is the identifier for the Finder search shortcut
                  "65" = {
                    enabled = false;
                  };
                  # Mission Control: Move left a space
                  "79" = {
                    enabled = true;
                  };
                  # Mission Control: Move right a space
                  "81" = {
                    enabled = true;
                  };
                  # Siri keyboard shortcut (Type to Siri)
                  "176" = {
                    enabled = false;
                  };
                };
              };
              NSGlobalDomain = {
                AppleShowAllFiles = true;
                # Add a context menu item for showing the Web Inspector in web views
                WebKitDeveloperExtras = true;
                # "com.apple.trackpad.threeFingerDrag" = true;
              };
            };
          };
          # needs logout/login to take effect

          # home manager
          users.users.benszabo.home = "/Users/benszabo";
          home-manager.backupFileExtension = "backup";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          stable = import nixpkgs-stable {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
        };
        modules = [
          configuration
          ./modules/homebrew/common.nix
          ./modules/system-packages/common.nix

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
