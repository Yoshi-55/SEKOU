class UpdateJobStatusEnum < ActiveRecord::Migration[7.1]
  def up
    # 既存のdraft(0)のレコードをpending_payment(0)に変更
    # 既存のpending_payment(1)をpending_payment(0)に変更
    # 既存のpublished(2)をpublished(1)に変更
    # 既存のclosed(3)をclosed(2)に変更

    execute <<-SQL
      UPDATE jobs SET status = 0 WHERE status = 1;
      UPDATE jobs SET status = 1 WHERE status = 2;
      UPDATE jobs SET status = 2 WHERE status = 3;
    SQL
  end

  def down
    # ロールバックは行わない（draft状態は削除されるため）
    raise ActiveRecord::IrreversibleMigration
  end
end
