{ config, pkgs, lib, ... }:

{
  # DiscordをWaylandネイティブで動作させる Flatpak オーバーライド
  home.file.".local/share/flatpak/overrides/com.discordapp.Discord".text = ''
    [Environment]
    ELECTRON_OZONE_PLATFORM_HINT=wayland
  '';

  # Steam: XwaylandアプリにカーソルテーマをNixストア経由で適用
  # ~/.local/share/icons/* は Nix ストアへのシンボリックリンクのため /nix/store:ro が必要
  home.file.".local/share/flatpak/overrides/com.valvesoftware.Steam".text = ''
    [Context]
    filesystems=/nix/store:ro;

    [Environment]
    XCURSOR_THEME=Bibata-Modern-Classic
    XCURSOR_SIZE=24
  '';

  services.flatpak = {
    enable = true;

    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];

    packages = [
      { appId = "com.discordapp.Discord";                  origin = "flathub"; }
      { appId = "com.valvesoftware.Steam";                 origin = "flathub"; }
      { appId = "io.gitlab.librewolf-community";            origin = "flathub"; }
      { appId = "com.github.tchx84.Flatseal";             origin = "flathub"; }
      { appId = "org.mozilla.Thunderbird";                 origin = "flathub"; }
      { appId = "org.mozilla.firefox";                    origin = "flathub"; }
      { appId = "org.telegram.desktop";			origin = "flathub"; }
      { appId = "com.yubico.yubioath";                        origin = "flathub"; }
    ];

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}
