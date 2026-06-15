# modules/homebrew/work.nix
# Homebrew packages for work machines (euphoric-mac)
{ ... }:
{
  homebrew = {
    brews = [
      "python"
      "uv"

    ];
    casks = ["google-cloud-sdk"];
  };
}
