class Project < ActiveRecord::Base
  before_create { self.share_id = SecureRandom.hex(16) }

  has_many :pages
  belongs_to :user

  validates :user, presence: true

  default_scope { includes(:pages).order(created_at: :desc) }
end
