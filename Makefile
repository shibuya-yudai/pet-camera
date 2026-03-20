.PHONY: format lint check test setup

# ツールセットアップ
setup:
	brew bundle

# フォーマット（自動修正）
format:
	swiftformat Packages/

# リント（チェックのみ、修正しない）
lint:
	swiftformat --lint Packages/
	swiftlint lint Packages/

# フォーマット + リント + テスト
check: format lint test

# テスト
test:
	cd Packages/PCCore && swift test
	cd Packages/PCTracking && swift test
