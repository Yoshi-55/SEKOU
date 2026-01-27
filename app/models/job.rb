class Job < ApplicationRecord
  # Associations
  belongs_to :client, class_name: 'User'
  has_many :applies, dependent: :destroy
  has_many :craftsmen, through: :applies, source: :craftsman
  has_many :payments, dependent: :destroy
  has_many_attached :images

  # Enums
  enum status: {
    pending_payment: 0,
    published: 1,
    closed: 2
  }

  # Validations
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 2000 }
  validates :job_type, presence: true
  validates :location, presence: true
  validates :budget, presence: true, numericality: { greater_than: 0 }
  validate :budget_must_be_multiple_of_5000
  validates :scheduled_date, presence: true
  validates :required_people, presence: true, numericality: { greater_than: 0 }

  # Scopes
  scope :published_jobs, -> { where(status: :published).where('expires_at > ?', Time.current) }
  scope :featured_jobs, -> { where(featured: true) }
  scope :urgent_jobs, -> { where(urgent: true) }
  scope :recent, -> { order(created_at: :desc) }

  # Methods
  def publish!
    now = Time.current
    days = extended_period ? 60 : 30
    update!(
      status: :published,
      published_at: now,
      expires_at: now + days.days
    )
  end

  def close!
    update!(status: :closed)
  end

  def calculate_total_price
    base_price = 5000
    total = base_price
    total += 3000 if featured
    total += 2000 if urgent
    total += 3000 if extended_period
    total
  end

  private

  def budget_must_be_multiple_of_5000
    if budget.present? && budget % 5000 != 0
      errors.add(:budget, 'は5000円単位で入力してください')
    end
  end
end
