# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :group_memberships, dependent: :destroy
  has_many :members, through: :group_memberships, source: :user
  has_many :jobs, dependent: :nullify

  validates :name, presence: true, length: { maximum: 100 }

  # オーナーが自動的にメンバーに含まれるようにする
  after_create :add_owner_as_member

  private

  def add_owner_as_member
    group_memberships.create!(user: owner, role: :admin)
  end
end
