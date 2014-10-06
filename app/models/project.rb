class Project < ActiveRecord::Base
  before_create { self.share_id = SecureRandom.hex(16) }

  has_many :pages
  belongs_to :user

  validates :user, presence: true

  default_scope { order(created_at: :desc) }

  acts_as_punchable

end
