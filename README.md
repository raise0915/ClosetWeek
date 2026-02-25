# ClosetWeek

ClosetWeek は、1週間分のコーディネート計画を作成・編集・保存するための SwiftUI アプリケーションです。

## 主な機能
- **Week**: 週プランの生成、日別編集、保存
- **Closet**: 服アイテム一覧と編集フォーム
- **Suggestion**: 条件入力にもとづく提案生成と詳細表示
- **Settings**: 地域設定フォームなどの基本設定

## 技術スタック
- Swift 5.9+
- SwiftUI
- SwiftData（永続化）
- Swift Package Manager

## ディレクトリ構成
- `Sources/ClosetWeek/App`: アプリ起動・タブ構成
- `Sources/ClosetWeek/Features`: 画面別 View / ViewModel
- `Sources/ClosetWeek/Shared`: ナビゲーション・Store
- `Sources/ClosetWeek/Domain`: モデル・Repository/UseCase プロトコル
- `Sources/ClosetWeek/Data`: InMemory/SwiftData/HTTP の実装
- `Tests/ClosetWeekTests`: 各レイヤーの単体テスト

## 開発コマンド
```bash
swift test
```

## 実装方針
実装方針・PR分割ルールは `docs/` 配下を参照してください。
- `docs/実装指針.md`
- `docs/PR分割ルール.md`
