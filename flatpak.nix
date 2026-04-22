{ config, pkgs, lib, ... }:

{
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
      { appId = "org.telegram.desktop";			origin = "flathub";}
    ];

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}
