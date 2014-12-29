# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  title       :string(255)
#  thumbnail   :string(255)
#  share_id    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  pages_count :integer          default("0"), not null
#  crits_count :integer          default("0"), not null
#  private     :boolean          default("t"), not null
#  deleted_at  :datetime
#
# Indexes
#
#  index_projects_on_deleted_at  (deleted_at)
#  index_projects_on_user_id     (user_id)
#

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
