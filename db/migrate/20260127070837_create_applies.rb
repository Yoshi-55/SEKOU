# frozen_string_literal: true

class CreateApplies < ActiveRecord::Migration[7.1]
  def change
    create_table :applies do |t|
      # 応募情報
      t.text :message, null: false
      t.integer :desired_budget
      t.date :available_date

      # ステータス
      t.integer :status, default: 0, null: false
      t.datetime :applied_at
      t.datetime :responded_at

      # 関連
      t.references :job, null: false, foreign_key: true
      t.references :craftsman, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :applies, :status
    add_index :applies, %i[job_id craftsman_id], unique: true
  end
end
