class Apply < ApplicationRecord
  # Associations
  belongs_to :job
  belongs_to :craftsman, class_name: 'Craftsman'

  # Enums
  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2,
    cancelled: 3
  }

  # Validations
  validates :message, presence: true, length: { maximum: 1000 }
  validates :job_id, uniqueness: { scope: :craftsman_id, message: 'この案件には既に応募済みです' }

  # Callbacks
  before_create :set_applied_at

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :for_craftsman, ->(craftsman_id) { where(craftsman_id: craftsman_id) }
  scope :for_job, ->(job_id) { where(job_id: job_id) }

  # Methods
  def accept!
    update!(status: :accepted, responded_at: Time.current)
    # TODO: メール通知を送信
  end

  def reject!
    update!(status: :rejected, responded_at: Time.current)
  end

  def cancel!
    return false unless pending?
    update!(status: :cancelled)
  end

  private

  def set_applied_at
    self.applied_at = Time.current
  end
end
