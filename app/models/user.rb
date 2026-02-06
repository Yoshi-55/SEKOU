class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :jobs, foreign_key: 'client_id', dependent: :destroy
  has_many :applies, foreign_key: 'craftsman_id', dependent: :destroy
  has_many :owned_groups, class_name: 'Group', foreign_key: 'owner_id', dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships

  # Validations
  validates :name, presence: true
  validates :phone, presence: true
end
