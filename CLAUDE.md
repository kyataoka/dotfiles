# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

macOS（Apple Silicon対応）のドットファイル管理および初期セットアップ自動化リポジトリ。シェルスクリプト（zsh）で構成され、Homebrew・asdf・Prezto等のツールインストールからシステム設定まで一括で行う。

## コマンド

```bash
# フルセットアップ（対話的に実行される）
./install.sh

# 現在のHomebrew構成をBrewfileにエクスポート
./update_brewfile.sh

# 全設定・パッケージの完全削除
./uninstall.sh
```

テストやLintの仕組みは導入されていない。

## アーキテクチャ

### セットアップフロー

`install.sh` が以下のスクリプトを順番に実行する：

1. `bin/config.sh` — コンピュータ名・ホスト名を対話的に設定し `config.ini` に保存
2. `bin/init.sh` — Xcode CLI Tools、Rosetta 2、Prezto、Homebrewのインストール
3. `bin/link.sh` — `files/` 配下の設定ファイルを `~/` にシンボリックリンク
4. `bin/brew.sh` — `files/Brewfile` に基づきパッケージ一括インストール
5. `bin/asdf.sh` — asdf経由でNode.js・Flutter・Golangをインストール
6. `bin/node.sh` — yarn・pnpmをグローバルインストール
7. `bin/system_config.sh` — macOSシステム設定（キーボード、Dock、Finder等）を `defaults write` で適用

### ディレクトリ構成

- `bin/` — セットアップスクリプト群（上記7ファイル）
- `files/` — シンボリックリンクされる設定ファイル群
  - `zshrc` — Prezto初期化、PATH設定（Homebrew, asdf, Go, pnpm等）
  - `vimrc` — dein.vimプラグインマネージャ、ファイルタイプ別設定
  - `tmux.conf` — プレフィックス `C-q`、viモード、日本語コメント
  - `zpreztorc` — Preztoモジュール設定（viキーバインド）
  - `git/gitconfig` — 1PasswordのSSH署名統合、Darwin固有設定を `include`
  - `Brewfile` — Homebrew formula・cask・MASアプリの一覧（100+エントリ）
  - `dein.toml`, `dein_lazy.toml` — Vimプラグイン定義
- `config.ini` — マシン固有設定（gitignore対象、`config.ini.example` がテンプレート）
- `backup/` — `uninstall.sh` 実行時のBrewfileバックアップ先

### 設計上の特徴

- 全スクリプトが `set -e` で実行され、エラー時に即停止
- シンボリックリンク方式のため非破壊的かつ冪等（再実行可能）
- `config.ini` によるマシン固有設定の分離（名前・ホスト名）
- Git署名は1Password SSH鍵（ed25519）を使用
