# 施工募集

カーラッピング・フリートなどの施工案件を、グループ内の仲間だけで共有・マッチングするプラットフォームです。

---

## 機能概要

- **グループ機能**: 信頼できる仲間でグループを作成し、メンバーのみに案件を公開
- **案件管理**: グループメンバー全員が案件を掲載・応募可能
- **応募管理**: 応募の承認/不承認、詳細住所は承認後に表示
- **履歴管理**: 応募履歴・募集履歴の確認

---

## 技術スタック

- **Ruby on Rails 7.x**
- **PostgreSQL**
- **Sidekiq + Redis**（非同期処理）
- **Tailwind CSS**
- **Hotwire (Turbo/Stimulus)**
- **Devise**（認証）
- **Docker / Docker Compose**

---

## データモデル

### User
- email, password, name, phone
- company_name, company_address
- prefecture, skills, bio, years_of_experience

### Group
- name, description
- owner（User）
- has_many members through GroupMemberships

### Job（案件）
- title, description, job_type
- location（都道府県）, address（詳細住所）
- budget, scheduled_date, required_people
- status（published / closed）
- belongs_to group（必須）, belongs_to client（User）

### Apply（応募）
- message
- status（pending / accepted / rejected / cancelled）
- applied_at, responded_at
- belongs_to job, belongs_to craftsman（User）

---

## セットアップ

```bash
# コンテナ起動
docker compose up -d

# DB作成・マイグレーション・サンプルデータ投入
docker compose exec web rails db:create db:migrate db:seed
```

---

## 実行コマンド

```bash
# コンソール
docker compose exec web rails console

# マイグレーション
docker compose exec web rails db:migrate

# サンプルデータ再投入
docker compose exec web rails db:seed:replant

# アセットプリコンパイル
docker compose exec web rails assets:precompile
```

---

## 環境変数

```
DATABASE_URL=postgres://postgres:password@db:5432/postgres
REDIS_URL=redis://redis:6379/1
```

---

## デモアカウント

```
client1@example.com / password123
client2@example.com / password123
craftsman1@example.com / password123
craftsman2@example.com / password123
craftsman3@example.com / password123
```
