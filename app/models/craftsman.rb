class Craftsman < User
  # Associations
  has_many :applies, foreign_key: 'craftsman_id', dependent: :destroy
  has_many :jobs, through: :applies

  # Validations
  validates :prefecture, presence: true
end
