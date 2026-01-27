class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :jobs, foreign_key: 'client_id', dependent: :destroy
  has_many :applies, foreign_key: 'craftsman_id', dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :phone, presence: true
end
