class RemoveJobPostingOptions < ActiveRecord::Migration[7.1]
  def change
    remove_column :jobs, :featured, :boolean
    remove_column :jobs, :urgent, :boolean
    remove_column :jobs, :extended_period, :boolean
  end
end
