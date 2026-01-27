class Client < User
  # Associations
  has_many :jobs, foreign_key: 'client_id', dependent: :destroy

  # Validations
  validates :company_name, presence: true
  validates :prefecture, presence: true
end
