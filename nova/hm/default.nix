{ inputs, ... }:
{
  imports = [
    ./home.nix
    ./discord.nix
    ./kitty.nix
    ./tmux.nix
    ./firefox
  ];
}
