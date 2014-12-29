# == Schema Information
#
# Table name: crits
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  comment    :text
#  x          :integer
#  y          :integer
#  width      :integer
#  height     :integer
#  order      :integer
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  deleted_at :datetime
#
# Indexes
#
#  index_crits_on_deleted_at  (deleted_at)
#  index_crits_on_page_id     (page_id)
#  index_crits_on_user_id     (user_id)
#

class Crit < ActiveRecord::Base
  belongs_to :page, counter_cache: true, touch: true
  belongs_to :user
  has_one :project, through: :page

  counter_culture [:page, :project]

  default_scope { includes(:user) }

  acts_as_paranoid

  validates :user, presence: true
end
