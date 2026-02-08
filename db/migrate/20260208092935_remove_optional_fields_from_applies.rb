# frozen_string_literal: true

class RemoveOptionalFieldsFromApplies < ActiveRecord::Migration[7.1]
  def change
    remove_column :applies, :desired_budget, :integer
    remove_column :applies, :available_date, :date
  end
end
