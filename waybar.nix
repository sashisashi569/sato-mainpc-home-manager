{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;

    settings = [{
      layer    = "top";
      position = "bottom";
      height   = 22;

      modules-left   = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [];
      modules-right  = [
        "cpu"
        "memory"
        "disk"
        "network"
        "pulseaudio"
        "clock"
        "tray"
      ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs    = true;
        format         = "{id}";
        on-click       = "activate";
      };

      "hyprland/window" = {
        max-length     = 60;
        separate-outputs = true;
      };

      cpu = {
        interval = 2;
        format   = "CPU: {usage:3}%";
        states   = { warning = 70; critical = 90; };
      };

      memory = {
        interval = 5;
        format   = "MEM: {percentage:3}%";
        tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        states   = { warning = 80; critical = 95; };
      };

      disk = {
        interval = 30;
        format   = "DISK: {percentage_used}%";
        path     = "/";
      };

      network = {
        interval          = 5;
        format-ethernet   = "ETH: {ipaddr} ↑{bandwidthUpBytes} ↓{bandwidthDownBytes}";
        format-wifi       = "W: {essid} ({signalStrength}%) ↑{bandwidthUpBytes} ↓{bandwidthDownBytes}";
        format-disconnected = "NET: disconnected";
        tooltip-format-wifi = "{ifname}: {ipaddr}\nSSID: {essid}\nStrength: {signalStrength}%";
        tooltip-format-ethernet = "{ifname}: {ipaddr}";
      };

      pulseaudio = {
        format        = "VOL: {volume:3}% {icon}";
        format-muted  = "VOL: MUTED";
        format-icons  = { default = [ "" "" "" ]; };
        on-click      = "pavucontrol";
        scroll-step   = 2;
      };

      clock = {
        interval       = 1;
        format         = "{:%Y-%m-%d %H:%M:%S}";
        tooltip-format = "<big>{:%Y年%m月}</big>\n<tt><small>{calendar}</small></tt>";
      };

      tray = {
        spacing    = 8;
        icon-size  = 16;
      };
    }];

    style = ''
      * {
        border:        none;
        border-radius: 0;
        font-family:   "monospace";
        font-size:     13px;
        min-height:    0;
        margin:        0;
        padding:       0;
      }

      window#waybar {
        background-color: #1a1a1a;
        color:            #ffffff;
        border-top:       1px solid #333333;
      }

      /* ---- Workspaces ---- */
      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        padding:          0 6px;
        color:            #888888;
        background:       transparent;
        border-bottom:    2px solid transparent;
        border-radius:    0;
      }

      #workspaces button.active {
        color:         #ffffff;
        border-bottom: 2px solid #ffffff;
      }

      #workspaces button.urgent {
        color: #cc0000;
      }

      #workspaces button:hover {
        background:    rgba(255,255,255,0.08);
        border-bottom: 2px solid #aaaaaa;
        color:         #ffffff;
      }

      /* ---- Window title ---- */
      #window {
        padding: 0 10px;
        color:   #888888;
      }

      /* ---- Right modules common ---- */
      #cpu,
      #memory,
      #disk,
      #network,
      #pulseaudio,
      #clock,
      #tray {
        padding:     0 10px;
        border-left: 1px solid #333333;
      }

      /* ---- Module colors (i3-status palette) ---- */
      #cpu {
        color: #f0c674;
      }
      #cpu.warning  { color: #e5c07b; }
      #cpu.critical { color: #cc0000; }

      #memory {
        color: #b5bd68;
      }
      #memory.warning  { color: #e5c07b; }
      #memory.critical { color: #cc0000; }

      #disk {
        color: #8abeb7;
      }

      #network {
        color: #81a2be;
      }
      #network.disconnected {
        color: #cc0000;
      }

      #pulseaudio {
        color: #b294bb;
      }
      #pulseaudio.muted {
        color: #666666;
      }

      #clock {
        color:       #ffffff;
        font-weight: bold;
        padding-right: 12px;
      }

      #tray {
        padding-right: 8px;
      }
    '';
  };
}
