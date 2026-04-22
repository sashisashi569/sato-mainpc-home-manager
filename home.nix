{ config, pkgs, lib, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./flatpak.nix
  ];

  home.username = "sato";
  home.homeDirectory = "/home/sato";
  home.stateVersion = "25.11";

  nixpkgs.config.allowUnfree = true;

  # ========== パッケージ ==========
  home.packages = with pkgs; [
    vim
    gh            # GitHub CLI
    claude-code   # Claude Code CLI
    cider-2
  ];

  # ========== プログラム設定 ==========
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    # userName  = "your name";
    # userEmail = "your@email.com";
  };

  # ========== デフォルトアプリ ==========
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # ブラウザ
      "x-scheme-handler/http"              = "io.gitlab.librewolf-community.desktop";
      "x-scheme-handler/https"             = "io.gitlab.librewolf-community.desktop";
      "text/html"                          = "io.gitlab.librewolf-community.desktop";
      "application/xhtml+xml"              = "io.gitlab.librewolf-community.desktop";

      # メール
      "x-scheme-handler/mailto"            = "org.mozilla.Thunderbird.desktop";
      "message/rfc822"                     = "org.mozilla.Thunderbird.desktop";

      # ファイルマネージャ
      "inode/directory"                    = "org.kde.dolphin.desktop";

      # PDF
      "application/pdf"                    = "io.gitlab.librewolf-community.desktop";

      # テキスト
      "text/plain"                         = "kitty.desktop";

      # Claude CLI スキーム
      "x-scheme-handler/claude-cli"        = "claude-code-url-handler.desktop";
    };
  };

  xdg.configFile."mimeapps.list".force = true;

  # ========== 通知デーモン (mako) ==========
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;   # 5秒（ミリ秒）
      ignore-timeout = false;    # アプリが指定した timeout も上書き
    };
  };
}
