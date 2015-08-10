# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           default(""), not null
#  created_at :datetime
#  updated_at :datetime
#  provider   :string
#  uid        :string
#  name       :string
#  type       :string
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    name 'Factory User'
    provider 'factory_girl'
  end
end
