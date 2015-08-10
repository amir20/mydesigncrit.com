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

class AnonymousUser < User
  def self.create_guest
    create(name: 'Guest', provider: 'designcrit', email: "#{SecureRandom.hex}@designcrit.io")
  end
end
