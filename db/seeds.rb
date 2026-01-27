# Clear existing data
puts "Cleaning database..."
Apply.destroy_all
Job.destroy_all
User.destroy_all

# Create demo users
puts "Creating demo users..."

# クライアント1（依頼者）
client1 = User.create!(
  email: "client1@example.com",
  password: "password123",
  password_confirmation: "password123",
  name: "田中 太郎",
  company_name: "株式会社カーデザイン",
  prefecture: "東京都",
  phone: "03-1234-5678",
  company_address: "東京都渋谷区神南1-2-3",
  bio: "カーラッピング専門店を運営しています。高品質な施工を心がけています。"
)

# クライアント2（依頼者）
client2 = User.create!(
  email: "client2@example.com",
  password: "password123",
  password_confirmation: "password123",
  name: "佐藤 花子",
  company_name: "PPFプロテクション株式会社",
  prefecture: "神奈川県",
  phone: "045-9876-5432",
  company_address: "神奈川県横浜市西区みなとみらい2-3-4",
  bio: "PPF施工を中心に、車両保護フィルムの専門店を経営しています。"
)

# 職人1
craftsman1 = User.create!(
  email: "craftsman1@example.com",
  password: "password123",
  password_confirmation: "password123",
  name: "鈴木 一郎",
  company_name: "鈴木ラッピング工房",
  prefecture: "埼玉県",
  phone: "048-1111-2222",
  years_of_experience: 8,
  skills: "カーラッピング、PPF施工、3M認定施工技術者",
  bio: "8年の経験を持つカーラッピング職人です。丁寧な作業を心がけています。"
)

# 職人2
craftsman2 = User.create!(
  email: "craftsman2@example.com",
  password: "password123",
  password_confirmation: "password123",
  name: "高橋 美咲",
  company_name: "高橋フィルム施工",
  prefecture: "千葉県",
  phone: "043-3333-4444",
  years_of_experience: 5,
  skills: "窓ガラスフィルム施工、PPF施工、XPEL認定技術者",
  bio: "5年間フィルム施工一筋でやってきました。細かい作業が得意です。"
)

# 職人3
craftsman3 = User.create!(
  email: "craftsman3@example.com",
  password: "password123",
  password_confirmation: "password123",
  name: "山田 健太",
  company_name: "フリーランス",
  prefecture: "東京都",
  phone: "090-5555-6666",
  years_of_experience: 3,
  skills: "カーラッピング、フリート施工",
  bio: "フリーランスとして活動中。フリート施工の経験が豊富です。"
)

puts "Users created: #{User.count}"

# Create demo jobs
puts "Creating demo jobs..."

# 案件1: カーラッピング（公開中、応募あり）
job1 = Job.create!(
  client: client1,
  title: "高級セダンのフルラッピング施工募集",
  description: "高級セダン（メルセデスベンツ Sクラス）のフルラッピング施工をお願いします。\n\nカラー: マットブラック\n納期: 3日間を予定\n場所: 東京都渋谷区の弊社工場\n\n丁寧な施工ができる方を募集しています。経験豊富な方優遇。",
  job_type: "car_wrapping",
  location: "東京都",
  address: "渋谷区神南1-2-3 カーデザインビル1F",
  budget: 30000,
  scheduled_date: Date.today + 7.days,
  required_people: 2,
  status: :published,
  published_at: Time.current - 2.days,
  expires_at: Time.current + 28.days
)

# 案件2: フリート施工（公開中）
job2 = Job.create!(
  client: client1,
  title: "企業ロゴ入り商用車3台のラッピング",
  description: "企業の営業車両3台にロゴとデザインを施工します。\n\n車種: トヨタ ハイエース 3台\nデザイン: 側面に企業ロゴ\n納期: 2日間\n\n同じデザインを3台に施工するため、効率よく作業できる方を希望します。",
  job_type: "fleet",
  location: "東京都",
  address: "江東区豊洲2-1-1",
  budget: 25000,
  scheduled_date: Date.today + 10.days,
  required_people: 2,
  status: :published,
  published_at: Time.current - 1.day,
  expires_at: Time.current + 29.days
)

# 案件3: PPF施工（公開中）
job3 = Job.create!(
  client: client2,
  title: "新車スポーツカーのPPF施工",
  description: "納車されたばかりのポルシェ 911にPPFを施工します。\n\n施工範囲: フロント部分（ボンネット、フロントバンパー、ヘッドライト）\nフィルム: XPEL Ultimate Plus\n納期: 1日\n\nPPF施工経験必須。丁寧な作業ができる方を募集。",
  job_type: "ppf",
  location: "神奈川県",
  address: "横浜市西区みなとみらい2-3-4",
  budget: 35000,
  scheduled_date: Date.today + 5.days,
  required_people: 1,
  status: :published,
  published_at: Time.current - 3.days,
  expires_at: Time.current + 27.days
)

# 案件4: カーラッピング（公開中、応募なし）
job4 = Job.create!(
  client: client2,
  title: "スポーツカーのルーフラッピング",
  description: "BMW M4のルーフ部分のみカーボン調ラッピングを施工します。\n\n施工箇所: ルーフのみ\nカラー: カーボンブラック\n納期: 半日程度\n\n小規模な案件ですが、丁寧に仕上げていただける方を希望します。",
  job_type: "car_wrapping",
  location: "神奈川県",
  address: "横浜市西区みなとみらい2-3-4",
  budget: 15000,
  scheduled_date: Date.today + 14.days,
  required_people: 1,
  status: :published,
  published_at: Time.current,
  expires_at: Time.current + 30.days
)

# 案件5: その他（公開中）
job5 = Job.create!(
  client: client1,
  title: "ショールーム展示車の窓ガラスフィルム施工",
  description: "ショールームに展示する車両5台の窓ガラスにUVカットフィルムを施工します。\n\n車種: 高級輸入車5台\nフィルム: UVカット・断熱フィルム\n納期: 2日間\n場所: 渋谷区のショールーム\n\n窓ガラスフィルム施工の経験がある方を募集します。",
  job_type: "other",
  location: "東京都",
  address: "渋谷区神南1-2-3",
  budget: 20000,
  scheduled_date: Date.today + 12.days,
  required_people: 2,
  status: :published,
  published_at: Time.current - 1.day,
  expires_at: Time.current + 29.days
)

# 案件6: フリート（大阪）
job6 = Job.create!(
  client: client1,
  title: "配送トラック10台のフリート施工",
  description: "運送会社の配送トラック10台に企業ロゴとデザインを施工します。\n\n車種: 2tトラック 10台\nデザイン: 側面・後部に企業ロゴ\n納期: 5日間\n\n大規模案件のため、複数名で対応できるチームを優遇します。",
  job_type: "fleet",
  location: "大阪府",
  address: "大阪市中央区本町3-4-5",
  budget: 30000,
  scheduled_date: Date.today + 20.days,
  required_people: 3,
  status: :published,
  published_at: Time.current - 4.days,
  expires_at: Time.current + 26.days
)

puts "Jobs created: #{Job.count}"

# Create demo applications
puts "Creating demo applications..."

# job1への応募（鈴木さん - pending）
apply1 = Apply.create!(
  job: job1,
  craftsman: craftsman1,
  message: "8年の経験を持つカーラッピング職人です。高級車のフルラッピングも多数経験しております。\n\nメルセデスベンツのラッピング経験もあり、マットブラックの施工も得意としています。丁寧に仕上げますので、ぜひご検討ください。",
  desired_budget: 30000,
  available_date: job1.scheduled_date,
  status: :pending,
  applied_at: Time.current - 1.day
)

# job1への応募（高橋さん - pending）
apply2 = Apply.create!(
  job: job1,
  craftsman: craftsman2,
  message: "5年間フィルム施工をしてきましたが、最近カーラッピングの分野にも力を入れています。\n\n丁寧な作業が得意です。高級車の施工経験もありますので、安心してお任せください。",
  desired_budget: 28000,
  available_date: job1.scheduled_date,
  status: :pending,
  applied_at: Time.current - 6.hours
)

# job3への応募（鈴木さん - accepted）
apply3 = Apply.create!(
  job: job3,
  craftsman: craftsman1,
  message: "PPF施工の経験が豊富です。XPEL Ultimate Plusの施工経験も多数あります。\n\nポルシェなどのスポーツカーへの施工も経験しており、丁寧に作業いたします。",
  desired_budget: 35000,
  available_date: job3.scheduled_date,
  status: :accepted,
  applied_at: Time.current - 2.days,
  responded_at: Time.current - 1.day
)

# job2への応募（山田さん - pending）
apply4 = Apply.create!(
  job: job2,
  craftsman: craftsman3,
  message: "フリート施工の経験が豊富です。同じデザインを複数台に施工する作業は得意としています。\n\nハイエースへの施工経験も多数ありますので、効率よく作業できます。",
  desired_budget: 25000,
  available_date: job2.scheduled_date,
  status: :pending,
  applied_at: Time.current - 3.hours
)

# job5への応募（高橋さん - pending）
apply5 = Apply.create!(
  job: job5,
  craftsman: craftsman2,
  message: "窓ガラスフィルム施工が専門です。UVカット・断熱フィルムの施工経験も豊富です。\n\n5台の施工も問題なく対応できます。綺麗に仕上げますので、よろしくお願いいたします。",
  desired_budget: 20000,
  available_date: job5.scheduled_date,
  status: :pending,
  applied_at: Time.current - 12.hours
)

puts "Applications created: #{Apply.count}"

puts "\n=== Demo Data Summary ==="
puts "Users: #{User.count}"
puts "  - Clients: 2"
puts "  - Craftsmen: 3"
puts "Jobs: #{Job.count}"
puts "  - Published: #{Job.published.count}"
puts "Applications: #{Apply.count}"
puts "  - Pending: #{Apply.pending.count}"
puts "  - Accepted: #{Apply.accepted.count}"
puts "\n=== Login Credentials ==="
puts "Client 1: client1@example.com / password123"
puts "Client 2: client2@example.com / password123"
puts "Craftsman 1: craftsman1@example.com / password123"
puts "Craftsman 2: craftsman2@example.com / password123"
puts "Craftsman 3: craftsman3@example.com / password123"
