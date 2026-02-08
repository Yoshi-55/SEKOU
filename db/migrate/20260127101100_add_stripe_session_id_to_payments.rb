# frozen_string_literal: true

class AddStripeSessionIdToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :stripe_session_id, :string
  end
end
