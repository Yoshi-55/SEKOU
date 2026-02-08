# frozen_string_literal: true

class CreateGroupMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :group_memberships do |t|
      t.references :group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :role, default: 0

      t.timestamps
    end

    add_index :group_memberships, %i[group_id user_id], unique: true
  end
end
