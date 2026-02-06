class GroupMembership < ApplicationRecord
  belongs_to :group
  belongs_to :user

  enum role: {
    member: 0,
    admin: 1
  }

  validates :group_id, uniqueness: { scope: :user_id, message: "既にこのグループのメンバーです" }
end
