# RSpecテストスイート

## セットアップ

1. Gemfileに必要なgemを追加済みです。以下のコマンドでインストールしてください：

```bash
bundle install
```

2. RSpecの設定ファイルを生成済みです。以下のコマンドでデータベースをセットアップしてください：

```bash
rails db:create db:migrate RAILS_ENV=test
```

## テストの実行

```bash
# すべてのテストを実行
bundle exec rspec

# 特定のファイルのテストを実行
bundle exec rspec spec/models/profile_spec.rb

# 特定のテストを実行
bundle exec rspec spec/models/profile_spec.rb:10
```

## テストファイル構成

- `spec/models/` - モデルのテストファイル
- `spec/factories/` - FactoryBotのファクトリー定義
- `spec/support/` - テストの共通設定やヘルパー
  - `shared_examples/` - 共通テストの共有例

## 使用しているライブラリ

- **RSpec**: テストフレームワーク
- **FactoryBot**: テストデータの生成
- **Shoulda Matchers**: バリデーションやアソシエーションのテストを簡潔に記述

