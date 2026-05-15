# home-manager

NixOS の [Home Manager](https://github.com/nix-community/home-manager) をフレーク形式で管理する設定リポジトリ。

- **対象ユーザー**: `sato`
- **アーキテクチャ**: `x86_64-linux`
- **nixpkgs チャンネル**: `nixos-unstable`

## ファイル構成

| ファイル | 役割 |
|---|---|
| `flake.nix` | フレーク入力定義・`homeConfigurations` 出力 |
| `home.nix` | メインエントリ。パッケージ・git・XDG・SSH・mako など共通設定 |
| `hyprland.nix` | Hyprland ウィンドウマネージャ全設定 |
| `waybar.nix` | Waybar ステータスバー設定・スタイル |
| `flatpak.nix` | nix-flatpak による Flatpak パッケージ管理 |

## フレーク入力

| 入力 | 用途 |
|---|---|
| `nixpkgs` | パッケージソース (`nixos-unstable`) |
| `home-manager` | Home Manager 本体 |
| `nix-flatpak` | ユーザーサイドの Flatpak 管理 |
| `hyprland` | Hyprland 公式フレーク（nixpkgs より新しいバージョン用） |
| `aagl` | アニメゲームランチャー (崩壊: スターレイル など) |

## よく使うコマンド

```bash
# 設定を適用
home-manager switch --flake ~/.config/home-manager

# ビルドのみ（適用しない）
home-manager build --flake ~/.config/home-manager

# フレーク入力を最新に更新
nix flake update ~/.config/home-manager
```

## 編集ワークフロー

1. **ブランチ作成** — `master` には直接コミットせず、作業用ブランチを作る
   ```bash
   git checkout -b <ブランチ名>
   ```
2. **編集** — 対象の `.nix` ファイルを修正する
3. **リビルド＆テスト** — 設定を適用して動作確認する
   ```bash
   home-manager switch --flake ~/.config/home-manager
   ```
4. **修正** — エラーや不具合があれば修正して手順 3 に戻る
5. **コミット** — 動作確認が取れたらコミットする
6. **プッシュ＆PR 作成**
   ```bash
   git push -u origin <ブランチ名>
   gh pr create --base master --fill
   ```

## 設計上の慣習

- **コメント**: 日本語でセクションや意図を説明する
- **git ユーザー情報**: `homectl` から動的取得し `~/.config/git/user-from-homectl.conf` に書き出す。`home.nix` に直書きしない
- **unfree パッケージ**: `nixpkgs.config.allowUnfree = true` を `home.nix` で許可済み
- **Flatpak アプリ**: `flatpak.nix` の `packages` リストで一元管理。自動週次更新が有効
- **モニター設定**: `hyprland.nix` の `monitor` に `desc:` 形式でシリアル番号込みの識別子を使用
- **ファイル分割**: 設定が 50 行を超えてきたら専用の `.nix` ファイルに分割し、`home.nix` の `imports` に追記する
