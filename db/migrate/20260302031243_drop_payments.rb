class DropPayments < ActiveRecord::Migration[7.1]
  def change
    drop_table :payments do |t|
      t.references :job, null: false, foreign_key: true
      t.string :stripe_charge_id
      t.string :stripe_session_id
      t.integer :amount, null: false
      t.integer :status, default: 0, null: false
      t.datetime :paid_at
      t.timestamps

      t.index :stripe_charge_id, unique: true
      t.index :status
    end
  end
end
