class Craftsman < User
  # Associations
  has_many :applications, foreign_key: 'craftsman_id', dependent: :destroy
  has_many :jobs, through: :applications

  # Validations
  validates :prefecture, presence: true
end
