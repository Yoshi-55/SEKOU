# frozen_string_literal: true

class Job < ApplicationRecord
  # Serialization
  serialize :notified_member_ids, coder: JSON

  # Associations
  belongs_to :client, class_name: 'User'
  belongs_to :group
  has_many :applies, dependent: :destroy
  has_many :craftsmen, through: :applies, source: :craftsman

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
  validates :start_date, presence: true
  validate :end_date_must_be_after_start_date
  validates :required_people, presence: true, numericality: { greater_than: 0 }
  validates :group_id, presence: true

  # Scopes
  scope :published_jobs, -> { where(status: :published).where('expires_at > ?', Time.current) }
  scope :recent, -> { order(created_at: :desc) }

  # Methods
  def publish!
    now = Time.current
    update!(
      status: :published,
      published_at: now,
      expires_at: now + 30.days
    )
  end

  def close!
    update!(status: :closed)
  end

  JOB_TYPE_LABELS = {
    'car_wrapping' => 'カーラッピング施工',
    'fleet'        => 'フリート施工',
    'ppf'          => 'PPF施工',
    'other'        => 'その他'
  }.freeze

  def job_type_label
    JOB_TYPE_LABELS[job_type] || job_type
  end

  # 指定ユーザーが通知対象メンバーかチェック
  def visible_to?(user)
    return true if client == user # 投稿者は常に表示
    return false unless group.member_ids.include?(user.id) # グループメンバー以外は非表示

    # notified_member_idsが空またはnilの場合は全員に表示
    return true if notified_member_ids.blank?

    # 指定されたメンバーのみに表示（文字列と整数の両方に対応）
    notified_member_ids.map(&:to_i).include?(user.id)
  end

  private

  def budget_must_be_multiple_of_5000
    return unless budget.present? && budget % 5000 != 0

    errors.add(:budget, 'は5000円単位で入力してください')
  end

  def end_date_must_be_after_start_date
    return unless start_date.present? && end_date.present? && end_date < start_date

    errors.add(:end_date, 'は開始日以降の日付を指定してください')
  end
end
