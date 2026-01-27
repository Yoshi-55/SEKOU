# 施工募集（MVP）

**施工募集**は、カーラッピング・フリートなどの施工現場に対して
職人を募集する企業（依頼主）と、施工職人をマッチングするアプリです。

本アプリは **求人広告型（掲載課金）モデル**を採用し、
依頼主が案件を掲載する際に固定料金を支払う設計になっています。

---

## 目次

1. [機能概要](#機能概要)
2. [技術スタック](#技術スタック)
3. [MVP機能一覧](#mvp機能一覧)
4. [データモデル](#データモデル)
5. [画面設計](#画面設計)
6. [Docker構成](#docker構成)
7. [セットアップ](#セットアップ)
8. [環境変数](#環境変数)
9. [実行コマンド](#実行コマンド)
10. [開発ルール](#開発ルール)
11. [今後のTODO](#今後のtodo)

---

## 機能概要

- 依頼主（企業）が施工案件を作成
- 掲載オプションを選択（注目表示、急募タグなど）
- Stripe決済で掲載料を支払い（基本5,000円〜）
- 決済完了後に案件が公開（30日間 or 60日間）
- 職人が案件に応募
- 依頼主が応募を承認
- 承認時に職人へメール通知
- 施工は両者間で直接実施

---

## 技術スタック

- **Ruby on Rails 7.x**
- **PostgreSQL**
- **Sidekiq + Redis**（非同期処理）
- **ActiveStorage + S3**（画像保存）
- **Amazon SES**（メール送信）
- **Tailwind CSS**
- **Hotwire (Turbo/Stimulus)**
- **Devise + Pundit**（認証・権限）
- **Stripe**（掲載料決済）

---

## MVP機能一覧

### ユーザー管理

#### 依頼主（Client）
- アカウント登録（会社名、担当者名、メール、電話番号）
- ログイン/ログアウト
- プロフィール編集
- パスワードリセット
- Stripeカード情報登録

#### 職人（Craftsman）
- アカウント登録（名前、メール、電話番号、地域）
- ログイン/ログアウト
- プロフィール編集（スキル、経験年数、自己PR）
- パスワードリセット

#### 管理者（Admin）
- システム全体の管理権限
- ユーザー・案件・決済の閲覧・管理

### 案件管理

#### 依頼主機能
- 案件作成（タイトル、説明、施工場所、報酬額、施工日など）
- 掲載オプション選択
  - 注目表示（上位固定）: +3,000円
  - 急募タグ: +2,000円
  - 掲載期間延長（60日間）: +3,000円
- Stripe決済（掲載料 5,000円〜13,000円）
- 決済完了後に案件公開
- 応募者一覧の閲覧
- 応募者の承認/不承認
- 案件の編集（公開前のみ）・削除

#### 職人機能
- 公開案件の検索・閲覧
  - 地域、施工タイプ、報酬額、施工日でフィルタリング
  - キーワード検索
  - 新着順・報酬順・施工日順でソート
- 案件への応募（応募メッセージ、希望報酬など）
- 応募の取り消し（承認前のみ）
- 応募状況の確認（応募中、承認済み）

#### ステータスフロー
```
【案件】
draft（下書き）
  ↓ 決済完了
published（公開中）
  ↓ 掲載期限到達 or 手動終了
closed（募集終了）

【応募】
pending（承認待ち）
  ↓ 依頼主が操作
accepted（承認済み） or rejected（不承認）
  または
cancelled（職人が取り消し）
```

### 通知

#### 職人向け
- 応募承認時: メール通知
- アカウント認証・パスワードリセット: メール

#### 依頼主向け
- 応募受信時: メール通知
- 案件公開完了時: メール通知
- 決済完了時: メール通知

#### 配信方法
- すべてAmazon SES経由でメール送信
- 非同期処理（Sidekiq）で送信

### 料金プラン

#### 基本掲載料
- **スポット掲載**: 5,000円/案件（30日間）

#### オプション（追加料金）
- **注目表示**: +3,000円（検索結果の上位に固定表示）
- **急募タグ**: +2,000円（急募バッジを表示）
- **掲載期間延長**: +3,000円（60日間掲載）

#### 料金例
```
基本のみ: 5,000円
基本 + 注目表示: 8,000円
基本 + 注目表示 + 急募タグ: 10,000円
全オプション: 13,000円
```

#### 将来実装予定
- **ライトプラン**: 15,000円/月（3案件まで、オプション割引）
- **ビジネスプラン**: 30,000円/月（無制限、全オプション無料）

---

## データモデル

### User（ユーザー）

**STI（Single Table Inheritance）で役割を分離**

```ruby
# 共通フィールド
- email (string, required, unique)
- password_digest (string, required)
- name (string, required)
- phone (string, required)
- type (string) # Client, Craftsman, Admin

# Client（依頼主）固有
- company_name (string, required)
- company_address (text)
- stripe_customer_id (string)

# Craftsman（職人）固有
- prefecture (string) # 都道府県
- skills (text) # スキル・経験
- bio (text) # 自己PR
- years_of_experience (integer) # 経験年数
```

### Job（案件）

```ruby
# 基本情報
- title (string, required) # 案件タイトル
- description (text, required) # 詳細説明
- job_type (string, required) # カーラッピング、フリート等
- location (string, required) # 施工場所（都道府県・市区町村）
- address (text) # 詳細住所
- budget (integer, required) # 報酬額（円）
- scheduled_date (date, required) # 施工予定日
- required_people (integer, default: 1) # 募集人数

# 掲載オプション
- featured (boolean, default: false) # 注目表示
- urgent (boolean, default: false) # 急募タグ
- extended_period (boolean, default: false) # 掲載期間延長

# ステータス管理
- status (integer) # draft, pending_payment, published, closed
- published_at (datetime) # 公開日時
- expires_at (datetime) # 掲載期限

# 関連
- client_id (references User)
- has_many :applications
- has_many_attached :images # ActiveStorage
```

### Application（応募）

```ruby
# 応募情報
- message (text, required) # 応募メッセージ
- desired_budget (integer) # 希望報酬（案件と異なる場合）
- available_date (date) # 対応可能日

# ステータス
- status (integer) # pending, accepted, rejected, cancelled
- applied_at (datetime) # 応募日時
- responded_at (datetime) # 承認/不承認日時

# 関連
- job_id (references Job)
- craftsman_id (references User)
```

### Payment（決済記録）

```ruby
# Stripe決済情報
- amount (integer, required) # 決済額（円）
- stripe_charge_id (string) # Stripe Charge ID
- status (integer) # pending, succeeded, failed, refunded

# オプション内訳
- base_price (integer) # 基本料金
- featured_price (integer) # 注目表示料金
- urgent_price (integer) # 急募タグ料金
- extended_price (integer) # 掲載期間延長料金

# 関連
- job_id (references Job)
- paid_at (datetime) # 決済完了日時
```

---

## 画面設計

### 共通

- **ヘッダー**: ロゴ、ナビゲーション、ログイン/ログアウト
- **フッター**: 利用規約、プライバシーポリシー、運営会社情報

### トップページ（未ログイン）

- サービス説明
- 依頼主向けCTA（案件を掲載する）
- 職人向けCTA（案件を探す）
- 新着案件一覧（プレビュー）

### 依頼主向け画面

#### 1. ダッシュボード
- 掲載中の案件一覧
- 応募者数の確認
- 過去の案件履歴

#### 2. 案件作成
- 基本情報入力フォーム
- 掲載オプション選択（リアルタイムで料金計算）
- プレビュー機能
- 決済画面（Stripe Checkout）

#### 3. 案件詳細（自分の案件）
- 案件情報表示
- 応募者リスト
- 承認/不承認ボタン
- 編集・削除ボタン（公開前のみ）

#### 4. 応募者詳細
- 職人のプロフィール
- 応募メッセージ
- スキル・経験
- 承認/不承認ボタン

### 職人向け画面

#### 1. 案件一覧（検索）
- 検索フォーム
  - 地域（都道府県）
  - 施工タイプ
  - 報酬額範囲
  - 施工日範囲
  - キーワード
- ソート機能（新着順、報酬順、施工日順）
- 案件カード表示
  - 注目表示（上位固定）
  - 急募タグ表示

#### 2. 案件詳細
- 案件情報詳細表示
- 応募フォーム
- 応募ボタン

#### 3. マイページ
- 応募中の案件
- 承認された案件
- プロフィール編集

### 管理者向け画面

#### 1. ダッシュボード
- ユーザー数（依頼主、職人）
- 案件数（公開中、過去）
- 売上サマリー

#### 2. ユーザー管理
- ユーザー一覧
- 詳細表示
- アカウント停止機能（将来）

#### 3. 案件管理
- 全案件一覧
- 不適切な案件の削除

#### 4. 売上管理
- 決済履歴
- 月次レポート

---

## Docker構成

Dockerでの開発環境を提供します。

### サービス構成
- **web**: Railsアプリ
- **db**: PostgreSQL
- **redis**: Sidekiq用
- **sidekiq**: バックグラウンドジョブ

---

### Dockerfile

```dockerfile
FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["bash", "-lc", "bundle exec rails server -b 0.0.0.0 -p 3000"]
```

---

### docker-compose.yml

```yaml
version: "3.9"
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - db_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7
    ports:
      - "6379:6379"

  web:
    build: .
    command: bash -lc "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0 -p 3000"
    volumes:
      - .:/app
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgres://postgres:password@db:5432/postgres
      REDIS_URL: redis://redis:6379/1
    depends_on:
      - db
      - redis

  sidekiq:
    build: .
    command: bundle exec sidekiq
    volumes:
      - .:/app
    environment:
      DATABASE_URL: postgres://postgres:password@db:5432/postgres
      REDIS_URL: redis://redis:6379/1
    depends_on:
      - db
      - redis

volumes:
  db_data:
```

---

## セットアップ

### Dockerで起動

```bash
docker compose up -d
```

### DB作成・マイグレーション

```bash
docker compose exec web rails db:create
docker compose exec web rails db:migrate
docker compose exec web rails db:seed
```

---

## 環境変数

`.env` または `credentials` に設定する項目例：

```
DATABASE_URL=postgres://postgres:password@db:5432/postgres
REDIS_URL=redis://redis:6379/1

# Amazon SES
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=...

# Stripe
STRIPE_SECRET_KEY=...
STRIPE_PUBLISHABLE_KEY=...
STRIPE_WEBHOOK_SECRET=...
```

---

## 実行コマンド

```bash
docker compose exec web rails server -b 0.0.0.0 -p 3000
docker compose exec web rails console
docker compose exec web rails db:migrate
docker compose exec web rails db:rollback
```

---

## 開発ルール

- ブランチは `feature/xxx` 形式
- PRは必ずレビューを通す
- テストは最低限 `RSpec` で実装
- コードスタイルは `Rubocop` に準拠

---

## 今後のTODO

### フェーズ2（MVP後すぐ）
- 月額プラン（ライトプラン、ビジネスプラン）
- 案件画像の追加枚数オプション（5枚 → 10枚）
- 管理者向けダッシュボードの強化（売上分析、利用統計）
- お気に入り機能（職人が案件をブックマーク）
- アプリ内通知（ベルアイコン）

### フェーズ3（拡張機能）
- 職人のレビュー・評価機能
- 依頼主から職人への評価機能
- メッセージ機能（承認後のやりとり）
- プッシュ通知（LINE通知、ブラウザ通知）
- 成功報酬オプションの追加（無料掲載 + 成約時10%）
- 掲載期間自動延長機能
- ポートフォリオ機能（職人の施工実績）
- 複数地域掲載オプション
- SNSシェア機能
- CSV一括案件登録（大企業向け）
