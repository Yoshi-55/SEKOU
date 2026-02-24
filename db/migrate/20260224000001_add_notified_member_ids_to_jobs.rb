# frozen_string_literal: true

class AddNotifiedMemberIdsToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :notified_member_ids, :text
  end
end
