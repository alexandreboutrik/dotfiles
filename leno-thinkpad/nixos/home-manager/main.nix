{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
  home-nix = "/etc/nixos/home-manager";
  home-scripts = "/etc/nixos/home-manager/scripts";
in
{
  imports = [ (import "${home-manager}/nixos") ];

  home-manager.users.boutrik = { pkgs, ... }: {
    home.stateVersion = "25.05";

    home.file = {
      /* Hyprland */
      ".config/hypr" = {
        source = "${home-nix}/hypr";
        recursive = true; force = true;
      };

      /* Waybar */
      ".config/waybar" = {
        source = "${home-nix}/waybar";
        recursive = true; force = true;
       };

      /* Wofi */
      ".config/wofi" = {
        source = "${home-nix}/wofi";
        recursive = true; force = true;
      };
      
      /* Scripts */
      ".bin" = {
        source = "${home-scripts}";
        recursive = true; force = true;
      };
      ".bashrc" = {
        source = "${home-nix}/bashrc";
        force = true;
      };
    };
  };
}
