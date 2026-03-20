# Packages 共通規約

## 型設計

- 値型は struct + Equatable + Sendable。Codable は永続化が必要な型のみ
- ステートレスサービスは enum の static メソッド
- ドメイン判別は associated value 付き enum
- stored property は本質的データのみ。導出値は計算プロパティ

## MARK 規約

- ファイルレベル: `// MARK: - [モジュール名]: [型名]`
- メソッドグループ: `// MARK: - [説明]`

## テスト

- フレームワーク: Swift Testing（`@Suite` / `@Test`）
- ファイル名: {型名}Tests.swift（1対1対応）
- `swift test` で全パッケージ実行、`make test` でも可

## フォーマット

- `make format`（SwiftFormat）を変更後に実行
- 設定: `.swiftformat`（120文字幅, 4スペース）, `.swiftlint.yml`
