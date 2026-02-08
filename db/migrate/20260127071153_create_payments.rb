# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      # Stripe決済情報
      t.integer :amount, null: false
      t.string :stripe_charge_id
      t.integer :status, default: 0, null: false

      # オプション内訳
      t.integer :base_price, null: false
      t.integer :featured_price, default: 0
      t.integer :urgent_price, default: 0
      t.integer :extended_price, default: 0

      # 決済日時
      t.datetime :paid_at

      # 関連
      t.references :job, null: false, foreign_key: true

      t.timestamps
    end

    add_index :payments, :status
    add_index :payments, :stripe_charge_id, unique: true
  end
end
