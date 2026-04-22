{
  description = "Home Manager configuration for sato";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ユーザーサイドのFlatpakインストール管理
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # Hyprlandの最新版 (nixpkgsより新しい場合に使用)
    hyprland.url = "github:hyprwm/Hyprland";

  };

  outputs = { nixpkgs, home-manager, nix-flatpak, hyprland, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations."sato" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nix-flatpak.homeManagerModules.nix-flatpak
          hyprland.homeManagerModules.default
          ./home.nix
        ];
      };
    };
}
