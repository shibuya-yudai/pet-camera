# PetCamera - Claude Development Guide

バーチャルペットカメラ。ARKit Face Tracking でヘッドトラッキングし、パララックス効果で「画面＝窓」体験を実現。窓の向こうにコーギーが自律行動している。

## パッケージ構成

```
PCCore(依存なし)     ← PCScene ← PCFeatures
PCTracking(依存なし) ← PCScene ← PCFeatures
App ← PCFeatures（薄いシェル）
```

- **PCCore** = ドメインモデル（PetNeeds, PetAction, PetBrain）
- **PCTracking** = 顔トラッキング（ARKit, パララックスカメラ計算）
- **PCScene** = RealityKit 3Dシーン（部屋 + ペット + アニメーション）
- **PCFeatures** = SwiftUI + ViewModel

## 開発ツール

| コマンド | 用途 |
|---------|------|
| `make format` | SwiftFormat でコードを自動整形 |
| `make lint` | SwiftFormat (--lint) + SwiftLint でスタイル・品質チェック |
| `make check` | format + lint + test を一括実行 |
| `make test` | 全パッケージのテスト実行 |
| `make setup` | 開発ツールのインストール（`brew bundle`） |

## セッションのルール

- コード変更後: `make format` → コミット
