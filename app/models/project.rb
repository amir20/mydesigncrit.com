class Project < ActiveRecord::Base
  before_create do
    self.share_id = loop do
      random_token = SecureRandom.urlsafe_base64(4)
      break random_token unless Project.find_by_share_id(random_token)
    end
  end

  has_many :pages
  belongs_to :user

  default_scope { includes(:pages).order(created_at: :desc) }
  scope :updated_since, -> (since) { where('updated_at > ?', since) }
  scope :created_since, -> (since) { where('created_at > ?', since) }
  scope :not_user, -> (user) { where('user_id != ?', user) }

  acts_as_punchable
  acts_as_paranoid

  validates :user, presence: true
end
