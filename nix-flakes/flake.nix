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
      stable = import nixpkgs-stable {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };

      configuration =
        { pkgs, stable, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          nixpkgs.config.allowUnfree = true;

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
          programs.zsh.enable = true;
          programs.zsh.enableCompletion = false;
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
            NSGlobalDomain = {
              AppleInterfaceStyle = "Dark";
              AppleShowAllFiles = true;
            };
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
                # Additional finder preferences can be added here
              };
              # Reference https://gist.github.com/mkhl/455002#file-ctrl-f1-c-L12
              "com.apple.symbolichotkeys" = {
                AppleSymbolicHotKeys = {
                  # Disable Ctrl + Space and Opt + Ctrl + Space for input source selection (next/prev)
                  "60" = {
                    enabled = false;
                  };
                  "61" = {
                    enabled = false;
                  };
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
                  # Mission Control: Move left a space (use 80 for slower speed)
                  "79" = {
                    enabled = 1;
                    value = {
                      parameters = [
                        65535
                        123
                        8650752
                      ];
                      type = "standard";
                    };
                  };
                  # Mission Control: Move right a space (use 81 for slower speed)
                  "81" = {
                    enabled = 1;
                    value = {
                      parameters = [
                        65535
                        124
                        8650752
                      ];
                      type = "standard";
                    };
                  };
                  # Siri keyboard shortcut (Type to Siri)
                  "176" = {
                    enabled = false;
                  };
                };
              };
              NSGlobalDomain = {
                # Add a context menu item for showing the Web Inspector in web views
                WebKitDeveloperExtras = true;
              };
            };
          };
          # needs logout/login to take effect

          home-manager.backupFileExtension = "backup";
        };

      mkDarwinConfiguration =
        {
          username,
          homebrewUser ? username,
          homebrewProfile,
        }:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit stable; };
          modules = [
            configuration
            {
              system.primaryUser = username;
              users.users.${username}.home = "/Users/${username}";
              homebrew.user = homebrewUser;
              nix-homebrew.user = homebrewUser;
            }
            ./modules/homebrew/common.nix
            homebrewProfile
            ./modules/system-packages/common.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }

            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
              };
            }
          ];
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#macbook
      # $ darwin-rebuild build --flake .#euphoric-mac
      darwinConfigurations = {
        macbook = mkDarwinConfiguration {
          username = "benszabo";
          homebrewProfile = ./modules/homebrew/personal.nix;
        };
        euphoric-mac = mkDarwinConfiguration {
          username = "benszabo";
          homebrewUser = "benszabo-a";
          homebrewProfile = ./modules/homebrew/work.nix;
        };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = {
        macbook = self.darwinConfigurations.macbook.pkgs;
        euphoric-mac = self.darwinConfigurations.euphoric-mac.pkgs;
      };
    };
}
