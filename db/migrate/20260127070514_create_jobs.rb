# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :job_type, null: false
      t.string :location, null: false
      t.text :address
      t.integer :budget, null: false
      t.date :scheduled_date, null: false
      t.integer :required_people, default: 1, null: false

      # 掲載オプション
      t.boolean :featured, default: false, null: false
      t.boolean :urgent, default: false, null: false
      t.boolean :extended_period, default: false, null: false

      # ステータス管理
      t.integer :status, default: 0, null: false
      t.datetime :published_at
      t.datetime :expires_at

      # 関連
      t.references :client, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :jobs, :status
    add_index :jobs, :published_at
    add_index :jobs, :job_type
    add_index :jobs, :location
  end
end
