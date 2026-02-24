# frozen_string_literal: true

class ChangeScheduledDateToDateRange < ActiveRecord::Migration[7.1]
  def change
    rename_column :jobs, :scheduled_date, :start_date
    add_column :jobs, :end_date, :date
  end
end
