class AddGroupIdToJobs < ActiveRecord::Migration[7.1]
  def change
    add_reference :jobs, :group, null: true, foreign_key: true
  end
end
