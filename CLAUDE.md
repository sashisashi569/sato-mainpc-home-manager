# Home Manager 設定プロジェクト

## 概要

NixOS の Home Manager をフレーク形式で管理する設定リポジトリ。
対象ユーザー: `sato` / システム: `x86_64-linux`

## ファイル構成

| ファイル | 役割 |
|---|---|
| `flake.nix` | フレーク入力定義・homeConfigurations 出力 |
| `home.nix` | メインエントリ。パッケージ・git・XDG・mako など共通設定 |
| `hyprland.nix` | Hyprland ウィンドウマネージャ全設定 |
| `waybar.nix` | Waybar ステータスバー設定・スタイル |
| `flatpak.nix` | nix-flatpak によるFlatpakパッケージ管理 |

## ファイル分割ルール

- 分量が大きくなるコンポーネント（Hyprland など）は専用の `.nix` ファイルに分割する
- 分割したファイルは `home.nix` の `imports` に追記して読み込む
- 目安: 設定が 50 行を超えてきたら分割を検討する
- ファイル名はコンポーネント名をそのまま使う（例: `waybar.nix`、`hyprland.nix`）

## 編集ワークフロー

1. **編集** — 対象の `.nix` ファイルを修正する
2. **リビルド＆テスト** — 以下のコマンドで適用・動作確認する
   ```bash
   home-manager switch --flake ~/.config/home-manager
   ```
3. **修正** — エラーや不具合があれば修正して手順 2 に戻る
4. **コミット** — 動作確認が取れたらコミットする

## フレーク入力

- `nixpkgs`: `nixos-unstable` を使用（安定版ではなく最新を追う）
- `home-manager`: nixpkgs に追従
- `nix-flatpak`: Flatpak のユーザーサイド管理
- `hyprland`: nixpkgs より新しいバージョンが必要な場合に公式フレークから取得

## 設計上の慣習

- **コメント**: 日本語でセクションや意図を説明する
- **git ユーザー情報**: `homectl` から動的取得し `~/.config/git/user-from-homectl.conf` に書き出す。`home.nix` に直書きしない
- **unfree パッケージ**: `nixpkgs.config.allowUnfree = true` を `home.nix` で許可済み
- **Flatpak アプリ**: `flatpak.nix` の `packages` リストで一元管理。自動週次更新が有効
- **モニター設定**: `hyprland.nix` の `monitor` に `desc:` 形式でシリアル番号込みの識別子を使用

## よく使うコマンド

```bash
# 設定を適用
home-manager switch --flake ~/.config/home-manager

# ビルドのみ（適用しない）
home-manager build --flake ~/.config/home-manager

# フレーク入力を最新に更新
nix flake update ~/.config/home-manager
```
