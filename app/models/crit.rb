class Crit < ActiveRecord::Base
  belongs_to :page, counter_cache: true, touch: true
  belongs_to :user
  has_one :project, through: :page

  counter_culture [:page, :project]

  default_scope { includes(:user) }

  validates :user, presence: true
end
