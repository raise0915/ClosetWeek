# PR分割ルール（機能単位）

ClosetWeek ではレビュー効率とリスク低減のため、PRは機能単位で分割します。

## 原則
- 1PR = 1機能（Week / Closet / Suggestion / Settings のいずれか1つ）
- 複数機能にまたがる変更はPRを分ける
- 例外的に共通基盤変更（`Shared/`, `Domain/`, `Data/`）を含む場合も、主対象機能を1つに絞る

## 推奨PR構成
- PR A: Feature実装（例: WeekのUI導線）
- PR B: その機能に対応するテスト追加
- PR C: 必要な共通基盤調整（小さく分離）

## CIチェック
- `PR Scope Check` ワークフローで、`Sources/ClosetWeek/Features/*` の変更範囲を検査
- 複数Featureディレクトリの同時変更はCI失敗

## 迷った時
- まず `docs/実装指針.md` を見直す
- それでも不明な場合は、実装前に分割案を相談する
