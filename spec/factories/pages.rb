# == Schema Information
#
# Table name: pages
#
#  id          :integer          not null, primary key
#  project_id  :integer
#  url         :string(255)
#  title       :string(255)
#  screenshot  :string(255)
#  thumbnail   :string(255)
#  width       :integer
#  height      :integer
#  processed   :boolean          default("f")
#  created_at  :datetime
#  updated_at  :datetime
#  crits_count :integer          default("0"), not null
#  deleted_at  :datetime
#
# Indexes
#
#  index_pages_on_deleted_at  (deleted_at)
#  index_pages_on_project_id  (project_id)
#
FactoryGirl.define do
  factory :page do
    url 'http://amirraminfar.com'
    title 'Factory Page'
    width 1024
    height 3000
    processed true
  end
end
