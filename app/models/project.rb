class Project < ActiveRecord::Base
  before_create { self.share_id = SecureRandom.hex(16) }

  has_many :pages
  belongs_to :user

  default_scope { includes(:pages).order(created_at: :desc) }
  scope :updated_since, -> (since) { where('updated_at > ?', since) }
  scope :not_user, -> (user) {where('user_id != ?', user)}

  acts_as_punchable

  validates :user, presence: true
end
