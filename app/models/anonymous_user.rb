# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string(255)      default(""), not null
#  created_at :datetime
#  updated_at :datetime
#  provider   :string(255)
#  uid        :string(255)
#  name       :string(255)
#  type       :string(255)
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
