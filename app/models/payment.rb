class Payment < ApplicationRecord
  # Associations
  belongs_to :job

  # Enums
  enum status: {
    pending: 0,
    succeeded: 1,
    failed: 2,
    refunded: 3
  }

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :featured_price, numericality: { greater_than_or_equal_to: 0 }
  validates :urgent_price, numericality: { greater_than_or_equal_to: 0 }
  validates :extended_price, numericality: { greater_than_or_equal_to: 0 }
  validates :stripe_charge_id, uniqueness: true, allow_nil: true

  # Callbacks
  before_validation :calculate_amount, on: :create

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }

  # Methods
  def mark_as_succeeded!(charge_id)
    update!(
      status: :succeeded,
      stripe_charge_id: charge_id,
      paid_at: Time.current
    )
  end

  def mark_as_failed!
    update!(status: :failed)
  end

  def refund!
    update!(status: :refunded)
  end

  private

  def calculate_amount
    self.amount = base_price + featured_price + urgent_price + extended_price
  end
end
