{ config, pkgs, lib, aagl, system, ... }:

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
    aagl.packages.${system}.honkers-railway-launcher  # 崩壊: スターレイル ランチャー
  ];

  # ========== プログラム設定 ==========
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    # userName / userEmail は homectl から動的取得 (home.activation.gitUserFromHomectl 参照)
    settings = {
      include.path = "${config.home.homeDirectory}/.config/git/user-from-homectl.conf";
    };
  };

  # home-manager switch のたびに homectl からユーザー情報を取得して git 用 include ファイルを生成
  home.activation.gitUserFromHomectl = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    _name=$(${pkgs.systemd}/bin/homectl inspect ${config.home.username} --json=short 2>/dev/null \
      | ${pkgs.jq}/bin/jq -r '.realName // empty')
    _email=$(${pkgs.systemd}/bin/homectl inspect ${config.home.username} --json=short 2>/dev/null \
      | ${pkgs.jq}/bin/jq -r '.emailAddress // empty')

    mkdir -p "${config.home.homeDirectory}/.config/git"
    printf '[user]\n\tname = %s\n\temail = %s\n' "$_name" "$_email" \
      > "${config.home.homeDirectory}/.config/git/user-from-homectl.conf"
  '';

  # ========== カーソルテーマ ==========
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name    = "Bibata-Modern-Classic";
    size    = 24;
    gtk.enable = true;
    x11.enable = true;
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
